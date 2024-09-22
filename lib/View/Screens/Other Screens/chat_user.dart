

import 'dart:io';

import 'package:barter_system/Model/message.dart';
import 'package:barter_system/View/Constants/Widgets/message_card.dart';
import 'package:barter_system/linker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatUserScreen extends StatefulWidget {
  String name;
  String id;
  String pic;
  ChatUserScreen({required this.id,required this.name,required this.pic,super.key,});

  @override
  State<ChatUserScreen> createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  List<Message> _list = [];

  bool Send = false;

  //for handling message text changes
  final _textController = TextEditingController();

  //showEmoji -- for storing value of showing or hiding emoji
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_showEmoji) {
          setState(() => _showEmoji = !_showEmoji);
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        //app bar
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
      
        //body
        body: SafeArea(
          child: Stack(
            children: [
              StreamBuilder(
                stream: AuthService.getAllMessages(widget.id),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                  //if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const SizedBox();
                
                  //if some or all data is loaded then show it
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      _list = data
                          ?.map((e) => Message.fromJson(e.data()))
                          .toList() ??
                          [];
                
                      if (_list.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 60.0),
                          child: ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: 15),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  message: _list[index], id: widget.id,
                                );
                              }),
                        );
                      } else {
                        return const Center(
                          child: Text('Say Hii! 👋',
                              style: TextStyle(fontSize: 20)),
                        );
                      }
                  }
                },
              ),
              if (_isUploading)
                const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: CircularProgressIndicator(strokeWidth: 2))),
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _chatInput(),
                    if (_showEmoji)
                      Flexible(
                        child: SizedBox(
                          height: 300,
                          child: EmojiPicker(
                            textEditingController: _textController,
                            // config: const Config(
                            //   bgColor: Color.fromARGB(255, 234, 248, 255),
                            //   columns: 8,
                            //   emojiSizeMax: 32,
                            // ),
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
    );
  }

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //back button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
          ),

          //user profile picture
          // CircleAvatar(
          //         radius: 24,
          //         backgroundImage:
          //             AssetImage('assets/images/person.png'),
          //       ),
          CircleAvatar(
            radius: 22,
            backgroundColor: MyColors.primary,
            backgroundImage: NetworkImage(widget.pic),
          ),

          //for adding some space
          const SizedBox(width: 10),
          CustomText(text: widget.name, size: 15, weight: FontWeight.w500)
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() => _showEmoji = !_showEmoji);
              },
              icon:  Icon(Icons.emoji_emotions_outlined,
                  color: Theme.of(context).colorScheme.tertiary, size: 25)),
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: _textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          // onChanged: (_textController) {
                          //   if (_textController.isEmpty) {
                          //     setState(() {
                          //       showSend = false;
                          //     });
                          //   } else {
                          //     setState(() {
                          //       showSend = true;
                          //     });
                          //   }
                         // },
                          onTap: () {
                            if (_showEmoji)
                              setState(() => _showEmoji = !_showEmoji);
                          },
                          decoration: const InputDecoration(
                              hintText: 'Write your message',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      )),
                ],
              ),
            ),
          ),

           Row(
            children: [
              //pick image from gallery button
              IconButton(
                // onPressed: (){},
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    // Picking multiple images
                    final List<XFile> images =
                    await picker.pickMultiImage(imageQuality: 70);

                    // uploading & sending image one by one
                    for (var i in images) {
                      // Fluttertoast.showToast(msg: 'Image Path: ${i.path}');
                      setState(() => _isUploading = true);
                      await AuthService.sendChatImage(widget.id, File(i.path));
                      setState(() => _isUploading = false);
                    }
                  },
                  icon: Icon(Icons.attach_file,color: Theme.of(context).colorScheme.tertiary,)
              ),

              //take image from camera button
              IconButton(
                //onPressed: (){},
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    // Pick an image
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 70);
                    if (image != null) {
                      //log('Image Path: ${image.path}');
                      setState(() => _isUploading = true);

                      await AuthService.sendChatImage(
                          widget.id, File(image.path));
                      setState(() => _isUploading = false);
                    }
                  },
                  icon: Icon(Icons.camera_alt_outlined,color: Theme.of(context).colorScheme.tertiary,)
              ),
              MaterialButton(
                onPressed: () {
                  if (_textController.text.isNotEmpty) {
                    if (_list.isEmpty) {
                      //on first message (add user to my_user collection of chat user)
                      AuthService.sendFirstMessage(
                          widget.id, _textController.text, Type.text);
                    } else {
                      //simply send message
                      AuthService.sendMessage(
                          widget.id, _textController.text, Type.text);
                    }

                    setState(() {
                      _textController.text = '';
                    });
                  } else{
                    Fluttertoast.showToast(msg: "Can't send an empty message");
                  }
                },
                minWidth: 0,
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 5, left: 10),
                shape: const CircleBorder(),
                color: MyColors.secondary,
                child: Icon(Icons.send,color: Theme.of(context).colorScheme.tertiary,),
              )
            ],
          )
        ],
      ),
    );
  }
}