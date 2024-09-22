import 'dart:io';
import 'package:barter_system/linker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {

  final FirebaseAuth auth = FirebaseAuth.instance;

  String? uid = FirebaseAuth.instance.currentUser?.uid;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User get user => auth.currentUser!;

  static FirebaseStorage storage = FirebaseStorage.instance;

  Loading cont = Get.put(Loading());

  //----------------------------- SignUp function---------------------------------------------
  Future signUp(name,
      email,
      phone,
      password,
      confirmPass,) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        if (name.isNotEmpty &&
            email.isNotEmpty &&
            phone.isNotEmpty &&
            password.isNotEmpty &&
            confirmPass.isNotEmpty) {
          if (password == confirmPass) {
            if (password.length > 5) {
              cont.isClickedTrue();

              UserCredential userCredential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                email: email,
                password: password,
              );
              //return userCredential.user?.uid;
              String? userId = userCredential.user?.uid;
              try {
                await FirebaseFirestore.instance.collection('users')
                    .doc(userId)
                    .set({
                  'id': userId,
                  'userName': name,
                  'email': email,
                  'phone': phone,
                  'password': password,
                });
                updateDisplayName(name);
                updateEmail(email);
                updatePhoneNo(phone);
              }
              catch (e) {
                Get.snackbar("Ooops!", "Error Saving User Data");
              }
              Get.to(DisplayProfile());
              cont.isClickedFalse();
            } else {
              Get.snackbar(
                  "Error", "Passwords must contain atleast 6 characters");
            }
          } else {
            Get.snackbar("Passwords must be same", 'Check Password Again');
          }
        } else {
          Get.snackbar("Please Enter all the Fields", 'Some Fields are Empty');
        }
      } catch (e) {
        Get.snackbar("Error Creating Account",
            "Email Address is already in use by another account");
        cont.isClickedFalse();
      }
    }
    else {
      Get.snackbar(
          "Check Your Internet", "You are not connected to Internet"
      );
    }
  }

  void updateDisplayName(String newName) async {
    try {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(newName);
      print("Display name updated successfully");
    } catch (e) {
      print("Failed to update display name: $e");
    }
  }

// Update email
  void updateEmail(String newEmail) async {
    try {
      await FirebaseAuth.instance.currentUser?.updateEmail(newEmail);
      print("Email updated successfully");
    } catch (e) {
      print("Failed to update email: $e");
    }
  }

  void updatePhoneNo(String phNo) async {
    try {
      await FirebaseAuth.instance.currentUser?.updatePhoneNumber(
          phNo as PhoneAuthCredential);
      print("Email updated successfully");
    } catch (e) {
      print("Failed to update email: $e");
    }
  }


  //------------------------------------------- SignIn function ----------------------------------------------
  Future signIn(String email, String password) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result) {
      try {
        if (email.isNotEmpty && password.isNotEmpty) {
          cont.isClickedTrue();
          await auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          Get.to(NavBar());
          Get.offAll(NavBar(), predicate: (_) => false);
          cont.isClickedFalse();
        }
        else {
          Get.snackbar("Please Enter all the Fields", 'Some Fields are Empty');
        }
      } catch (error) {
        Get.snackbar("Error during sign in", "Account does not Exist");
        cont.isClickedFalse();
      }
    }
    else {
      Get.snackbar(
          "Check Your Internet!", "You are not connected to Internet"
      );
    }
  }

  //---------------------------------------------------Update about-------------------------------------------------
  Future bioUpdate(String about) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result) {
      try {
        if (about.isNotEmpty) {
          cont.isClickedTrue();
          await FirebaseFirestore.instance.collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .set({
            'about': about,
          }, SetOptions(merge: true));


          cont.isClickedFalse();
        }
        else {
          Get.snackbar("Please Enter Bio", 'Bio Must Not Be Empty');
        }
      } catch (error) {
        Get.snackbar("Error during updating data", "Data is not being updated");
        cont.isClickedFalse();
      }
    }
    else {
      Get.snackbar(
          "Check Your Internet!", "You are not connected to Internet"
      );
    }
  }

  //--------------------------------------------------- update profile Pic-------------------------------------------------
  Future usernameUpdate(String name) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result) {
      try {
        if (name.isNotEmpty) {
          cont.isClickedTrue();
          await FirebaseFirestore.instance.collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .set({
            'userName': name,
          }, SetOptions(merge: true));
          await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
          String? uid = FirebaseAuth.instance.currentUser?.uid;

// Update 'profilePic' field in the "posts" collection for documents with matching UID
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('posts')
              .where('uid', isEqualTo: uid)
              .get();

          querySnapshot.docs.forEach((doc) {
            doc.reference.update({'userName': name,});
          });


          cont.isClickedFalse();
        }
        else {
          Get.snackbar("Please Enter Username", 'UserName Must Not Be Empty');
        }
      } catch (error) {
        Get.snackbar("Error during updating data", "Data is not being updated");
        cont.isClickedFalse();
      }
    }
    else {
      Get.snackbar(
          "Check Your Internet!", "You are not connected to Internet"
      );
    }
  }

  //--------------------------------------------------- update profile Pic-------------------------------------------------
  Future profilePicUpdate(File file) async {
    bool result = await InternetConnectionChecker().hasConnection;
    final ext = file.path
        .split('.')
        .last;
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    final ref = storage.ref().child(
        'images/${FirebaseAuth.instance.currentUser!.uid}/$time.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      //log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await FirebaseAuth.instance.currentUser?.updatePhotoURL(
        imageUrl.toString());
    if (result) {
      try {
        cont.isClickedTrue();
        await FirebaseFirestore.instance.collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set({
          'profilePic': imageUrl,
        }, SetOptions(merge: true));

        String? uid = FirebaseAuth.instance.currentUser?.uid;

// Update 'profilePic' field in the "posts" collection for documents with matching UID
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: uid)
            .get();

        querySnapshot.docs.forEach((doc) {
          doc.reference.update({'profilePic': imageUrl});
        });

        cont.isClickedFalse();
      } catch (error) {
        Get.snackbar("Error during updating data", "Data is not being updated");
        cont.isClickedFalse();
      }
    }
    else {
      Get.snackbar(
          "Check Your Internet!", "You are not connected to Internet"
      );
    }
  }

  //--------------------------------------------------- User Data-----------------------------------------------------------
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserData() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  //-------------------------------------------------- SignOut function ---------------------------------------------------
  Future signOut() async {
    try {
      await auth.signOut();
      Get.snackbar("LogOut!",
          "You are Logged out Successfully");
      print("LogOut");
      Get.to(LogInScreen());
    } catch (error) {
      Get.snackbar("LogOut", "Error during sign out: $error");
      print("LogOut Error $error");
    }
  }

  //------------------------------------------------------------- Post --------------------------------------------------
  Future post(File file, description, exchange, location) async {
    //getting image file extension
    final ext = file.path
        .split('.')
        .last;
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${FirebaseAuth.instance.currentUser!.uid}/$time.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      //log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();


    bool result = await InternetConnectionChecker().hasConnection;
    if (result) {
      try {
        if (description.isNotEmpty &&
            exchange.isNotEmpty &&
            location.isNotEmpty) {
          try {
            await FirebaseFirestore.instance.collection('posts').doc(time).set(
                {
                  'uid': uid,
                  'userName': FirebaseAuth.instance.currentUser?.displayName,
                  'image': imageUrl,
                  'description': description,
                  'exchange': exchange,
                  'location': location,
                  'profilePic': FirebaseAuth.instance.currentUser!.photoURL,
                }).then((value) => Get.offAll(PostScreen()));
          }
          catch (e) {
            Get.snackbar("Ooops!", "Error Uploading Post");
          }
          cont.isClickedFalse();
        } else {
          Get.snackbar(
              "Please Enter all the Fields", 'Some Fields are Empty');
          cont.isClickedFalse();
        }
      } catch (e) {
        Get.snackbar(
            "Check Your Internet", "You are not connected to Internet"
        );
        cont.isClickedFalse();
      }
    }
  }


  //---------------------------------------------------------------Get All Posts----------------------------------------------
  static Stream<QuerySnapshot> getGridData() {
    final CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('posts');
    return collectionRef.snapshots();
  }

  //----------------------------------------------------------------Get User Posts---------------------------------------------
  static Stream<QuerySnapshot> currentUserPost() {
    final Query<Map<String, dynamic>> collectionRef = FirebaseFirestore.instance
        .collection('posts').where(
        'uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid);
    return collectionRef.snapshots();
  }

  ///************** Chat Screen Related APIs **************

  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // useful for getting conversation id
  static String getConversationID(String id) =>
      FirebaseAuth.instance.currentUser!.uid.hashCode <= id.hashCode
          ? '${FirebaseAuth.instance.currentUser!.uid}_$id'
          : '${id}_${FirebaseAuth.instance.currentUser!.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(String id) {
    return FirebaseFirestore.instance
        .collection('chats/${getConversationID(id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(String id, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    //message to send
    final Message message = Message(
        toId: id,
        msg: msg,
        read: '',
        type: type,
        fromId: FirebaseAuth.instance.currentUser!.uid.toString(),
        sent: time);

    final ref = FirebaseFirestore.instance
        .collection('chats/${getConversationID(id)}/messages/');
    await ref.doc(time).set(message.toJson());
    //then((value));
    //=>
    //  sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  }

// for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(String id, String msg, Type type) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('my_users')
        .doc(id)
        .set({})
        .then((value) => sendMessage(id, msg, type))
        .then((value) => recieveFirstMessage(id, msg, type));
  }

  static Future<void> recieveFirstMessage(String id, String msg,
      Type type) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('my_users')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .set({});
  }

  static Future<void> sendChatImage(String id, File file) async {
    //getting image file extension
    final ext = file.path
        .split('.')
        .last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(id)}/${DateTime
            .now()
            .millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      //log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(id, imageUrl, Type.image);
  }

  // //delete message
  static Future<void> deleteMessage(Message message) async {
    await FirebaseFirestore.instance
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    FirebaseFirestore.instance
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()});
  }

  //update message
  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await FirebaseFirestore.instance
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessagedUser(
      List<String> userIds) {
    //log('\nUserIds: $userIds');

    return FirebaseFirestore.instance
        .collection('users')
        .where('id',
        whereIn: userIds.isEmpty
            ? ['']
            : userIds) //because empty list throws an error
    // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('my_users')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(id) {
    return FirebaseFirestore.instance
        .collection('chats/${getConversationID(id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> unReadMessage(id) {
    return FirebaseFirestore.instance
        .collection('chats/${getConversationID(id)}/messages/')
        .where('fromId', isEqualTo: id)
        .where('read', isEqualTo: '')
        .snapshots();
  }

  static Future<void> deletePost(id, image, description, username, exchange,
      location) async {
    try {
      // Query Firestore to find the document ID based on post attributes
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: id)
          .where('image', isEqualTo: image)
          .where('description', isEqualTo: description)
          .where('userName', isEqualTo: username)
          .where('exchange', isEqualTo: exchange)
          .where('location', isEqualTo: location)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there is only one document that matches the query
        String docId = querySnapshot.docs.first.id;

        // Delete the document
        await FirebaseFirestore.instance.collection('posts')
            .doc(docId)
            .delete();
        Fluttertoast.showToast(msg: 'Post deleted successfully');
      } else {
        Fluttertoast.showToast(msg: 'No matching post found');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error deleting post: $e');
    }
  }

  static Future<void> reportPost(id, image, description, username, exchange,
      location) async {
    try {
      // Query Firestore to find the document ID based on post attributes
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: id)
          .where('image', isEqualTo: image)
          .where('description', isEqualTo: description)
          .where('userName', isEqualTo: username)
          .where('exchange', isEqualTo: exchange)
          .where('location', isEqualTo: location)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there is only one document that matches the query
        String docId = querySnapshot.docs.first.id;

        // Delete the document
        await FirebaseFirestore.instance.collection('posts')
            .doc(docId)
            .delete();
        Fluttertoast.showToast(msg: 'Post reported successfully');
      } else {
        Fluttertoast.showToast(msg: 'No matching post found');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error reporting post: $e');
    }
  }

  static Future<void> deleteChat(String id) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
    String conversationID = getConversationID(id);

    // Step 1: Delete all messages within the conversation
    QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(conversationID)
        .collection('messages')
        .get();

    for (var doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Step 2: Delete the conversation document
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(conversationID)
        .delete();

    // Step 3: Remove user ID from my_users subcollection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('my_users')
        .doc(id)
        .delete();

    Fluttertoast.showToast(msg: 'Chat deleted successfully');
  }

}






