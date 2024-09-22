
import 'dart:io';

import 'package:barter_system/linker.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';


class DisplayProfile extends StatefulWidget {
   DisplayProfile({super.key});

  @override
  State<DisplayProfile> createState() => _DisplayProfileState();
}

class _DisplayProfileState extends State<DisplayProfile> {
  TextEditingController aboutController=TextEditingController();
  final picker = ImagePicker();
  File? _image;
  Loading controller= Get.put(Loading());

  void openBottomSheet() {
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
                CustomText(text: "Choose Profile Image from :", size: 14, weight: FontWeight.w500),
                const SizedBox(height: 20,),
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
                              child:
                              Icon(CupertinoIcons.camera_on_rectangle,color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        CustomText(text: "Camera", size: 14, weight: FontWeight.w400)
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
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
                              child: Icon(CupertinoIcons.photo_on_rectangle,color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        CustomText(text: "Gallery", size: 14, weight: FontWeight.w400)
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

    setState(() {
      _image  = File(pickedFile!.path);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: CustomText(text: "Profile", size: 14, weight: FontWeight.w500),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 50,bottom: 10.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Stack(
                      children: [
                        _image == null
                            ? const CircleAvatar(
                          radius: 75.0,
                          backgroundColor: Colors.white,
                          backgroundImage:AssetImage( "assets/images/user.png", )
                        )
                            : CircleAvatar(
                            radius: 75.0,
                            backgroundImage: FileImage(File(_image!.path.toString()))
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            radius: 23,
                            backgroundColor: Theme.of(context).colorScheme.background,
                            child: InkWell(
                              onTap: (){
                                openBottomSheet();
                              },
                              child: const CircleAvatar(
                                radius: 20,
                                child: Icon(Icons.add),
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  CustomText(text: "Profile Picture", size: 13, weight: FontWeight.w500),
                  const SizedBox(height: 50,),
                  TextField(
                    controller: aboutController,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                          )),
                      prefixIcon: const Icon(Icons.info_outline,
                          color: MyColors.secondary),
                      hintText: 'About',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GetBuilder<Loading>(
                    builder: (con) {
                    return InkWell(
                        onTap: (){
                          if(_image==null&&aboutController.text==null){
                            AuthService().profilePicUpdate(_image!);
                            AuthService().bioUpdate(aboutController.text).then((value) => Get.to(NavBar()));
                            Get.offAll(NavBar(), predicate: (_) => false);
                          }
                          else{
                            Fluttertoast.showToast(msg: "Please provide required data");
                          }

                        },
                        child: ((con).loading)?LoadingButton():CustomButton(
                      text: 'Next',
                      ),);
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
