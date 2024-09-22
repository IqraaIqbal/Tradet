import 'package:barter_system/linker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List<ItemPostModel> list = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        flexibleSpace: customAppBar(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: MyColors.primary,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          icon: Icon(
                            CupertinoIcons.search,
                            color: Colors.white,
                          ),
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Grid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, right: 10, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              height: 60,
              width: 45,
              child: Image.asset("assets/images/logo.png"),
            ),
            Text(
              " Tradet",
              style: GoogleFonts.iceberg(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget Grid() {
    return StreamBuilder(
      stream: AuthService.getGridData(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
        // If data is loading
          case ConnectionState.waiting:
          case ConnectionState.none:
            return const SizedBox();

        // If some or all data is loaded then show it
          case ConnectionState.active:
          case ConnectionState.done:
            final data = snapshot.data?.docs;

            list = data
                ?.map((e) => ItemPostModel.fromJson(
                e.data() as Map<String, dynamic>))
                .toList() ??
                [];

            final filteredList = list.where((item) {
              final query = _searchController.text.toLowerCase();
              return item.description.toLowerCase().contains(query) ||
                  item.exchange.toLowerCase().contains(query) ||
                  item.location.toLowerCase().contains(query) ||
                  item.userName.toLowerCase().contains(query);
            }).toList();

            if (filteredList.isNotEmpty) {
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  mainAxisExtent: 300,
                ),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  String message = filteredList[index].description;
                  String displayText = message.length > 20
                      ? message.substring(0, 20)
                      : message;
                  String exchItem = filteredList[index].exchange;
                  String displayItem = exchItem.length > 15
                      ? exchItem.substring(0, 15)
                      : exchItem;
                  String location = filteredList[index].location;
                  String displayLoc = location.length > 13
                      ? location.substring(0, 13)
                      : location;

                  return InkWell(
                    onTap: () {
                      Get.to(PostDetails(
                        image: filteredList[index].image,
                        location: filteredList[index].location,
                        exchItem: filteredList[index].exchange,
                        description: filteredList[index].description,
                        userName: filteredList[index].userName,
                        profilePic: filteredList[index].profilePic,
                        id: filteredList[index].uid,
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: MyColors.primary,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              topLeft: Radius.circular(16),
                            ),
                            child: Image.network(
                              filteredList[index].image,
                              height: 170,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return const SizedBox(
                                    height: 170,
                                    width: double.infinity,
                                    child: Icon(
                                      CupertinoIcons.photo_on_rectangle,
                                      size: 50,
                                      color: Colors.white, // Placeholder icon color
                                    ),
                                  );
                                }
                              },
                              errorBuilder: (BuildContext context,
                                  Object exception,
                                  StackTrace? stackTrace) {
                                return const SizedBox(
                                  height: 170,
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.captions_bubble,
                                      color: MyColors.secondary,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    SizedBox(
                                      width: 110,
                                      child: Text.rich(
                                        TextSpan(
                                          text: (message.length > 20)
                                              ? '$displayText...'
                                              : displayText,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.shuffle_medium,
                                      color: MyColors.secondary,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    SizedBox(
                                      width: 110,
                                      child: Text.rich(
                                        TextSpan(
                                          text: (exchItem.length > 15)
                                              ? '$displayItem...'
                                              : displayItem,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.location_solid,
                                      color: MyColors.secondary,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    SizedBox(
                                      width: 110,
                                      child: Text.rich(
                                        TextSpan(
                                          text: (location.length > 13)
                                              ? '$displayLoc...'
                                              : displayLoc,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/no_con_avail.png"),
                  CustomText(
                    text: "No content available right now\n Be the first to add product 😊",
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ],
              );
            }
        }
      },
    );
  }
}