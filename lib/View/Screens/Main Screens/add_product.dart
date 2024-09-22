import 'package:barter_system/linker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  TextEditingController descController =TextEditingController();
  TextEditingController excController =TextEditingController();
  TextEditingController locationController =TextEditingController();
  String? _selectedLocation;

  final List<String> _locations = [
    'Karachi',
    'Lahore',
    'Islamabad',
    'Faisalabad',
    'Rawalpindi',
    'Multan',
    'Peshawar',
    'Quetta',
    'Sialkot',
    'Bahawalpur',
    'Sargodha',
    'Gujranwala',
    'Hyderabad',
    'Mardan',
    'Mirpur',
    'Gwadar',
    'Chiniot',
    'Jhang',
    'Kohat',
    'Larkana',
    'Nawabshah',
    'Okara',
    'Sukkur',
    'Dera Ghazi Khan',
    'Skardu',
    'Bannu',
    'Dera Ismail Khan',
    'Sadiqabad',
    'Jhelum',
    'Kharian',
    'Tando Adam',
    'Kotli',
    'Muzaffarabad',
    'Shikarpur',
    'Layyah',
    'Chowk Azam',
    'Remote'
  ];


  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Loading controller= Get.put(Loading());
    controller.isClickedFalse();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: CustomText(text: "Add Post", size: 16, weight: FontWeight.w500),
        actions: [
           (_imageFile == null)? const SizedBox():GetBuilder<Loading>(
             builder: (controller) {
               return SizedBox(
                 width: 100,
                 child: StreamBuilder(
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
                           List<UserModel> list = [];
                           final data = snapshot.data?.docs;
                           list = data
                               ?.map((e) => UserModel.fromJson(
                               e.data() as Map<String, dynamic>))
                               .toList() ??
                               [];

                           if (list.isNotEmpty) {
                             //print(FirebaseAuth.instance.currentUser!.photoURL);
                             return ListView.builder(
                               itemCount: list.length,
                               shrinkWrap: true,
                               itemBuilder: (context,index) {
                                 return Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: InkWell(
                                       onTap: (){
                                         controller.isClickedTrue();
                                         AuthService().post(_imageFile!, descController.text, excController.text, _selectedLocation);
                                       },
                                       child: ((controller).loading)?LoadingButton(width: 80,height: 35,):CustomButton(text: "Done",width: 80,height: 35,)),
                                 );
                               }
                             );
                           } else {
                             return SizedBox();
                           }
                       }
                     }),
               );
             }
           ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex:  (_imageFile == null)? 5:1,
              child: Container(
                color: Theme.of(context).colorScheme.background,
                child: _imageFile == null
                    ? Center(
                        child: CustomText(
                            text: "Select an option below to add your Item",
                            size: 14,
                            weight: FontWeight.w500),
                      )
                    : Image.file(_imageFile!, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              flex: 1,
              child: _imageFile == null
                  ?Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        _getImage(ImageSource.camera);
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
                  InkWell(
                      onTap: () {
                        _getImage(ImageSource.gallery);
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
                  )
                ],
              ):
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.tertiary,
                              )),
                          prefixIcon: const Icon(
                            CupertinoIcons.captions_bubble,
                            color: MyColors.secondary,
                          ),
                          hintText: 'Enter Description',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        controller: excController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.tertiary,
                              )),
                          prefixIcon: const Icon(
                            CupertinoIcons.shuffle_medium,
                            color: MyColors.secondary,
                          ),
                          hintText: 'Enter Trade Item',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary,
                              width: 1.0, // Adjust the width as needed
                            ),
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.location_solid,
                              color: MyColors.secondary,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedLocation,
                                  hint: Text(
                                    'Select Location',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  isExpanded: true,
                                  items: _locations.map((location) {
                                    return DropdownMenuItem<String>(
                                      value: location,
                                      child: Text(location),
                                    );
                                  }).toList(),
                                  onChanged: (String? newLocation) {
                                    setState(() {
                                      _selectedLocation = newLocation;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}