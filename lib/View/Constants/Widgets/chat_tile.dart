// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:barter_system/linker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatTile extends StatelessWidget {
  String id;
  String name;
  String pic;
  String about;
  ChatTile({
    super.key,
    required this.id,
    required this.name,
    required this.pic,
    required this.about,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.20,
        motion: ScrollMotion(),
        children: [
          InkWell(
            onTap: () {
              AuthService.deleteChat(id);
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red,
              // backgroundImage: AssetImage('assets/icons/trash_bin.png'),
              child: Icon(Icons.delete)
            ),
          ),
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child:
          CircleAvatar(
            radius: 20,
            backgroundColor: MyColors.primary,
            backgroundImage: NetworkImage(pic),
            //child: ,
          ),
        ),
        title: CustomText(text: name, size: 15, weight: FontWeight.w500,color: Theme.of(context).colorScheme.tertiary,),
        subtitle: StreamBuilder(
            stream: AuthService.getLastMessage(id),
            builder: (context, snapshot) {
              var list = [];
              //list<String> = [];
              final data = snapshot.data?.docs;
              list = data?.map((e) => (e.data())).toList() ?? [];
              if (list.isNotEmpty) {
                String message = list[0]['msg'];
                String type=list[0]['type'];
                String displayText =
                    message.length > 25 ? message.substring(0, 25) : message;
                return (type=='text')?Text(message.length > 25?'${displayText}...':'${displayText}',style: TextStyle(color: Theme.of(context).colorScheme.tertiary)):Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.image,color: Colors.grey,),
                    Text('Photo',style: TextStyle(color: Theme.of(context).colorScheme.tertiary),)
                  ],
                );
                //return Text('${list[0]['msg']}');
              } else {
                return CustomText(text: about, size: 13, weight: FontWeight.w400,color: Theme.of(context).colorScheme.tertiary,);
              }
            }),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: AuthService.getLastMessage(id),
                builder: (context, snapshot) {
                  var list = [];
                  //list<String> = [];
                  final data = snapshot.data?.docs;
                  list = data?.map((e) => (e.data())).toList() ?? [];
                  if (list.isNotEmpty) {
                    //return Text('${list[0]['sent']}');
                    return Text(
                      MyDateUtil.getFormattedTime(
                          context: context, time: '${list[0]['sent']}'),
                    style: TextStyle(
                      color:Theme.of(context).colorScheme.tertiary,
                    ),);
                  } else {
                    return Text('');
                  }
                }),
            StreamBuilder(
                stream: AuthService.unReadMessage(id),
                builder: (context, snapshot) {
                  //updateReadStatus(user);
                  var list = [];
                  final data = snapshot.data?.docs;
                  list = data?.map((e) => (e.data())).toList() ?? [];
      
                  if (list.isNotEmpty) {
      
                    return Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red.shade600,
                          child: Text(
                            '${list.length}',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text('');
                  }
                }),
          ],
        ),
        onTap: () {
          Get.to(ChatUserScreen(id: id, name: name ,pic: pic,));
          // Navigator.push(context,
          //     MaterialPageRoute(builder: ((context) => ChatUserScreen(id: id, name: name, pic: pic))));
        },
        onLongPress: (){
          // AuthService.deleteChat(id);
        },
      ),
    );
  }
}

