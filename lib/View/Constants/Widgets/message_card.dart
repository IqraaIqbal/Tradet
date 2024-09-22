// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, must_be_immutable

//import 'package:you_chat/View/Screens/OtherScreens/full_screen_image.dart';
import 'package:barter_system/Model/message.dart';
import 'package:barter_system/View/Constants/my_date_utils.dart';
import 'package:barter_system/View/Screens/Other%20Screens/full_screen_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import "package:barter_system/linker.dart";
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:gallery_saver/gallery_saver.dart';

// for showing single message details
class MessageCard extends StatefulWidget {
  MessageCard({super.key, required this.message, required this.id});

  final Message message;
  String id;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = FirebaseAuth.instance.currentUser?.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _greenMessage() : _blueMessage());
  }

  // sender or another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      AuthService.updateMessageReadStatus(widget.message);
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                padding:
                    EdgeInsets.all(widget.message.type == Type.image ? 5 : 12),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: MyColors.secondary,
                    //border: Border.all(color: Colors.lightBlue),
                    //making borders curved
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                child: widget.message.type == Type.text
                    ?
                    //show text
                    Text(
                        widget.message.msg,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                      )
                    :
                    //show image
                    InkWell(
                        onTap: () {
                          if (widget.message.msg.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImageView(
                                  imageUrls: [
                                    widget.message.msg
                                  ], // You can pass a list of image URLs here
                                ),
                              ),
                            );
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: widget.message.msg,
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.image, size: 70),
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(
              width: 50,
            )
          ],
        ),
        //message time
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: widget.message.sent),
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // our or user message
  Widget _greenMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 50,
            ),
            Flexible(
              child: Container(
                padding:
                    EdgeInsets.all(widget.message.type == Type.image ? 5 : 12),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: MyColors.primary,
                    //border: Border.all(color: Colors.teal),
                    //making borders curved
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
                child: widget.message.type == Type.text
                    ?
                    //show text
                    Text(
                        widget.message.msg,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      )
                    :
                    //show image
                    InkWell(
                        onTap: () {
                          if (widget.message.msg.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImageView(
                                  imageUrls: [
                                    widget.message.msg
                                  ], // You can pass a list of image URLs here
                                ),
                              ),
                            );
                          }
                        },
                        child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: widget.message.msg,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(strokeWidth: 2),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.image, size: 70),
                                ),
                              ),
                              ),
                      ),
              ),
          ],
        ),
        //message time
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //double tick blue icon for message read
            (widget.message.read.isEmpty)
                ? Icon(Icons.done, color: Colors.grey, size: 20)
                : Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),
            // if (widget.message.read.isNotEmpty)
            //   const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            //for adding some space
            const SizedBox(width: 2),

            //sent time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ],
    );
  }

  // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
            return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              widget.message.type == Type.text
                  ?
                  //copy option
                  _OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);

                          Fluttertoast.showToast(msg: 'Text Copied!');
                        });
                      })
                  :
                  //save option
                  _OptionItem(
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Save Image',
                      onTap: () {}
                      // () async {
                      //   try {
                      //     //log('Image Url: ${widget.message.msg}');
                      //     await GallerySaver.saveImage(widget.message.msg,
                      //             albumName: 'We Chat')
                      //         .then((success) {
                      //       //for hiding bottom sheet
                      //       Navigator.pop(context);
                      //       if (success != null && success) {
                      //         showToast(
                      //             context, 'Image Successfully Saved!');
                      //       }
                      //     });
                      //   } catch (e) {
                      //     showToast(context,'ErrorWhileSavingImg: $e');
                      //   }
                      // }
                      ),

              //separator or divider
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: 30,
                  indent: 30,
                ),

              //edit option
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                    name: 'Edit Message',
                    onTap: () {
                      //for hiding bottom sheet
                      Navigator.pop(context);

                      _showMessageUpdateDialog();
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: () async {
                      await AuthService.deleteMessage(widget.message).then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              //separator or divider
              Divider(
                color: Colors.black54,
                endIndent: 15,
                indent: 15,
              ),

              //sent time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  name:
                      'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              //read time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  //dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Update Message')
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                      AuthService.updateMessage(widget.message, updatedMsg);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}

//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(left: 30, top: 30, bottom: 30),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style:  TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.tertiary,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}
