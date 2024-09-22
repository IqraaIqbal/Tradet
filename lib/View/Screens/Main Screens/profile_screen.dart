import 'dart:io';
import 'package:barter_system/linker.dart';
import 'package:flutter/cupertino.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController aboutController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final picker = ImagePicker();

  File? _image;
  Loading controller = Get.put(Loading());

  void openBottomSheet(context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    text: "Choose Profile Image from :",
                    size: 14,
                    weight: FontWeight.w500),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _getImage(ImageSource.camera);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: MyColors.primary,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.camera_on_rectangle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(
                            text: "Camera", size: 14, weight: FontWeight.w400)
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            controller.isClickedTrue();
                            _getImage(ImageSource.gallery);
                            Navigator.of(context).pop();
                          },
                          child: Ink(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: MyColors.primary,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.photo_on_rectangle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(
                            text: "Gallery", size: 14, weight: FontWeight.w400)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(
      source: source,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        controller.isClickedFalse();
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: CustomText(
                text: 'Your Image will be shown as:',
                size: 13,
                weight: FontWeight.w500),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                    radius: 75.0,
                    backgroundImage: FileImage(File(_image!.path.toString()))),
                const SizedBox(height: 20),
                GetBuilder<Loading>(builder: (cont) {
                  //cont.isClickedFalse();
                  return InkWell(
                    onTap: () {
                      cont.isClickedTrue();
                      AuthService()
                          .profilePicUpdate(_image!)
                          .then((value) => Navigator.of(context).pop())
                          .then((value) => cont.isClickedFalse());
                    },
                    child: ((cont).loading)
                        ? LoadingButton()
                        : CustomButton(
                            text: 'Continue',
                          ),
                  );
                }),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          backgroundColor: Theme.of(context).colorScheme.background,
          centerTitle: true,
          title: CustomText(
              text: (FirebaseAuth.instance.currentUser!.email != null &&
                      FirebaseAuth.instance.currentUser!.email != '')
                  ? FirebaseAuth.instance.currentUser!.email!
                  : "Email",
              size: 14,
              weight: FontWeight.w500),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String result) {
                switch (result) {
                  case 'logout':
                    // Implement delete functionality
                    _showConfirmation(context);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Log Out'),
                ),
              ],
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                    stream: AuthService.getUserData(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          List<UserModel> _list = [];
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => UserModel.fromJson(e.data()))
                                  .toList() ??
                              [];
                          print(_list);

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: _list.length,
                              itemBuilder: (BuildContext context, int index) {
                                ImageProvider? dpProvider = ((_list[index]
                                                .profilePic ==
                                            null)
                                        ? AssetImage("assets/images/user.png")
                                        : NetworkImage(_list[index].profilePic))
                                    as ImageProvider<Object>;
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 130,
                                      width: 130,
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 60.0,
                                            backgroundColor: MyColors.primary,
                                            backgroundImage: dpProvider,
                                          ),
                                          Align(
                                              alignment: Alignment.bottomRight,
                                              child: CircleAvatar(
                                                radius: 23,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                                child: InkWell(
                                                  onTap: () {
                                                    openBottomSheet(context);
                                                  },
                                                  child: const CircleAvatar(
                                                    radius: 20,
                                                    child: Icon(Icons.add),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Flexible(
                                          child: CustomText(
                                              text: _list[index].userName,
                                              size: 13,
                                              weight: FontWeight.w500),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: CustomText(
                                                        text: 'Enter Username:',
                                                        size: 13,
                                                        weight:
                                                            FontWeight.w500),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        TextField(
                                                          controller:
                                                              nameController
                                                                ..text = _list[
                                                                        index]
                                                                    .userName,
                                                          decoration:
                                                              InputDecoration(
                                                            enabledBorder:
                                                                UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .tertiary,
                                                            )),
                                                            prefixIcon: const Icon(
                                                                Icons
                                                                    .person_outline,
                                                                color: MyColors
                                                                    .secondary),
                                                            hintText:
                                                                'UserName',
                                                            hintStyle:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        GetBuilder<Loading>(
                                                            builder: (cont) {
                                                          //cont.isClickedFalse();
                                                          return InkWell(
                                                            onTap: () {
                                                              cont.isClickedTrue();
                                                              AuthService()
                                                                  .usernameUpdate(
                                                                      nameController
                                                                          .text)
                                                                  .then((value) =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop())
                                                                  .then((value) =>
                                                                      cont.isClickedFalse());
                                                            },
                                                            child: ((cont)
                                                                    .loading)
                                                                ? LoadingButton()
                                                                : CustomButton(
                                                                    text:
                                                                        'Continue',
                                                                  ),
                                                          );
                                                        }),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: MyColors.secondary,
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text.rich(
                                            TextSpan(
                                              text: _list[index].about,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: CustomText(
                                                        text: 'Enter About:',
                                                        size: 13,
                                                        weight:
                                                            FontWeight.w500),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        TextField(
                                                          controller:
                                                              aboutController
                                                                ..text =
                                                                    _list[index]
                                                                        .about,
                                                          decoration:
                                                              InputDecoration(
                                                            enabledBorder:
                                                                UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .tertiary,
                                                            )),
                                                            prefixIcon: const Icon(
                                                                Icons
                                                                    .info_outline,
                                                                color: MyColors
                                                                    .secondary),
                                                            hintText: 'About',
                                                            hintStyle:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        GetBuilder<Loading>(
                                                            builder: (cont) {
                                                          //cont.isClickedFalse();
                                                          return InkWell(
                                                            onTap: () {
                                                              cont.isClickedTrue();
                                                              AuthService()
                                                                  .bioUpdate(
                                                                      aboutController
                                                                          .text)
                                                                  .then((value) =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop())
                                                                  .then((value) =>
                                                                      cont.isClickedFalse());
                                                            },
                                                            child: ((cont)
                                                                    .loading)
                                                                ? LoadingButton()
                                                                : CustomButton(
                                                                    text:
                                                                        'Continue',
                                                                  ),
                                                          );
                                                        }),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: MyColors.secondary,
                                            )),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Stack(
                                    children: [
                                      const CircleAvatar(
                                          radius: 75.0,
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                            "assets/images/user.png",
                                          )),
                                      Align(
                                          alignment: Alignment.bottomRight,
                                          child: CircleAvatar(
                                            radius: 23,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            child: InkWell(
                                              onTap: () {
                                                // openBottomSheet();
                                              },
                                              child: const CircleAvatar(
                                                radius: 20,
                                                child: Icon(Icons.add),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomText(
                                    text: "UserName",
                                    size: 13,
                                    weight: FontWeight.w500),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: CustomText(
                                      text: "Please Enter Your About",
                                      size: 13,
                                      weight: FontWeight.w400),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ],
                            );
                          }
                      }
                    }),
                StreamBuilder(
                    stream: AuthService.currentUserPost(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          List<ItemPostModel> list = [];
                          final data = snapshot.data?.docs;
                          list = data
                                  ?.map((e) => ItemPostModel.fromJson(
                                      e.data() as Map<String, dynamic>))
                                  .toList() ??
                              [];

                          if (list.isNotEmpty) {
                            //print(list.length);
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: list.length,
                                itemBuilder: (Context, index) {
                                  return Post(
                                    userName: list[index].userName,
                                    image: list[index].image,
                                    description: list[index].description,
                                    exchItem: list[index].exchange,
                                    location: list[index].location,
                                    dp: list[index].profilePic,
                                  );
                                });
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/no_con_avail.png",
                                  height: 300,
                                  width: 300,
                                ),
                                CustomText(
                                    text: "Sorry,You Have Currently No Post",
                                    size: 14,
                                    weight: FontWeight.w500)
                              ],
                            );
                          }
                      }
                    }),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ));
  }

  void _showConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to Log Out?'),
          actions: <Widget>[
            TextButton(
              child: CustomText(text: 'Cancel', size: 13, weight: FontWeight.w500,color: Theme.of(context).colorScheme.secondary,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: CustomText(text: 'Log Out', size: 13, weight: FontWeight.w500,color: Theme.of(context).colorScheme.secondary,),
              onPressed: () {
                // Perform delete action
                Navigator.of(context).pop();
                AuthService().signOut();
              },
            ),
          ],
        );
      },
    );
  }

}
