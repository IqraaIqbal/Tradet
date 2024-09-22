import 'package:barter_system/linker.dart';
import 'package:flutter/cupertino.dart';

class Post extends StatelessWidget {
   String userName;
   String image;
   String description;
   String exchItem;
   String location;
   String dp;
  Post({super.key, required this.userName,required this.image,required this.dp,required this.description,required this.exchItem,required this.location});

  @override
  Widget build(BuildContext context) {
    ImageProvider? dpProvider = ((dp == null) ? AssetImage("assets/images/user.png") : NetworkImage(dp)) as ImageProvider<Object>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                   CircleAvatar(
                    radius: 20,
                    backgroundColor: MyColors.primary,
                    backgroundImage: dpProvider,

                  ),
                  const Text("  "),
                  CustomText(text: userName, size: 13, weight: FontWeight.w500)
                ],
              ),
              PopupMenuButton<String>(
                onSelected: (String result) {
                  switch (result) {
                    case 'delete':
                    // Implement delete functionality
                      _showConfirmation(context);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete Post'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(16)
            ),
            child: Image.network(
              image,
              height: 300,
              fit: BoxFit.cover,
              width: double.infinity,
              loadingBuilder: (BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Icon(
                      CupertinoIcons.photo_on_rectangle,
                      size: 50,
                      color: Colors.white, // Placeholder icon color
                    ),
                  );
                  // Placeholder icon while loading
                }
              },
              errorBuilder:
                  (BuildContext context,
                  Object exception,
                  StackTrace? stackTrace) {
                return const SizedBox(
                  height: 300,
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
          SizedBox(
            height: 10,
          ),
          //--------------------Description----------------------------
          Text.rich(TextSpan(children: [
             TextSpan(text: "Description : ",style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),),
            TextSpan(text: description,style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),),
          ]),),
          const SizedBox(height: 5,),
          //------------------------trade----------------------------
          Text.rich(TextSpan(children: [
            TextSpan(text: "Exchange For : ",style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),),
            TextSpan(text: exchItem,style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),),
          ]),),
          const SizedBox(height: 5,),
          //------------------------location----------------------------
          Text.rich(TextSpan(children: [
            TextSpan(text: "Location : ",style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),),
            TextSpan(text: location,style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),),
          ]),),
          const SizedBox(height: 5,),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      ),
    );
  }

   void _showConfirmation(BuildContext context) {
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
               },
             ),
           ],
         );
       },
     );
   }

}
