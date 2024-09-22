import 'package:barter_system/linker.dart';
import 'package:flutter/cupertino.dart';

class PostDetails extends StatelessWidget {
  String image;
  String description;
  String exchItem;
  String location;
  String userName;
  String profilePic;
  String id;
  PostDetails(
      {super.key,
      required this.image,
      required this.location,
      required this.exchItem,
      required this.description,
      required this.userName,
      required this.profilePic,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16)),
                child: Image.network(
                  image,
                  height: 400,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: Icon(
                          CupertinoIcons.photo_on_rectangle,
                          size: 50,
                          color: Colors.white, // Placeholder icon color
                        ),
                      ); // Placeholder icon while loading
                    }
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: Icon(
                        CupertinoIcons.photo_on_rectangle,
                        size: 50,
                        color: Colors.white, // Placeholder icon color
                      ),
                    ); // Placeholder icon for no internet
                  },
                ),
              ),
              (id==FirebaseAuth.instance.currentUser!.uid)?SizedBox(height: 10,):Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.to(ChatUserScreen(id: id, name: userName,pic: profilePic,));
                      },
                      icon: const Icon(CupertinoIcons.text_bubble)),
                ],
              ),
              //--------------------Description----------------------------
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "Description : ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: description,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              //------------------------trade----------------------------
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "Exchange For : ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: exchItem,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              //------------------------location----------------------------
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "Location : ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: location,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0, left: 10),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_outlined)),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: MyColors.primary,
                  backgroundImage: NetworkImage(profilePic),
                  //child: ,
                ),
                Text("  "),
                CustomText(text: userName, size: 13, weight: FontWeight.w500),
              ],
            ),
            PopupMenuButton<String>(
              onSelected: (String result) {
                switch (result) {
                  case 'report':
                  // Implement delete functionality
                    _showReportConfirmation(context);
                    break;
                  case 'delete':
                  // Implement delete functionality
                    _showDeleteConfirmation(context);
                    break;

                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                (id != FirebaseAuth.instance.currentUser!.uid)?const PopupMenuItem<String>(
                  value: 'report',
                  child: Text('Report'),
                ):
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showReportConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report'),
          content: Text('Are you sure you want to Report the current post?'),
          actions: <Widget>[
            TextButton(
              child: CustomText(text: 'Cancel', size: 13, weight: FontWeight.w500,color: Theme.of(context).colorScheme.secondary,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: CustomText(text: 'Report', size: 13, weight: FontWeight.w500,color: Theme.of(context).colorScheme.secondary,),
              onPressed: () {
                // Perform delete action
                Navigator.of(context).pop();
                AuthService.reportPost(id, image, description, userName, exchItem, location);
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Post'),
          content: Text('Are you sure you want to delete the post?'),
          actions: <Widget>[
            TextButton(
              child: CustomText(text: 'Cancel', size: 13, weight: FontWeight.w500,color: Theme.of(context).colorScheme.secondary,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: CustomText(text: 'Delete', size: 13, weight: FontWeight.w500,color: Theme.of(context).colorScheme.secondary,),
              onPressed: () {
                // Perform delete action
                Navigator.of(context).pop();
                AuthService.deletePost(FirebaseAuth.instance.currentUser!.uid, image, description, userName, exchItem, location);
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

}
