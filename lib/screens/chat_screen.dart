import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwave/api/apis.dart';
import 'package:chatwave/model/chat_user.dart';
import 'package:chatwave/model/message.dart';
import 'package:chatwave/screens/widgets/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser chatUser;
  const ChatScreen({super.key, required this.chatUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appbar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: Api.getallmessages(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      // log("message");
                      // if (snapshot.hasData) {
                      final data = snapshot.data!.docs;
                      log('data ${jsonEncode(data[0].data())}');
                      //   list =
                      //       data.map((e) => ChatUser.fromjson(e.data())).toList() ??
                      //           [];
                      // }
                      _list.clear();
                      _list.add(Message(
                          toid: 'hai',
                          msg: 'hai',
                          read: '',
                          type: Type.text,
                          send: '12 pm',
                          fromid: Api.user.uid));
                      _list.add(Message(
                          toid: Api.user.uid,
                          msg: 'hallo',
                          read: '',
                          type: Type.text,
                          send: '12 pm',
                          fromid: 'xyz'));
                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          itemCount: _list.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(message: _list[index]);
                          },
                        );
                      } else {
                        return const Center(
                          child: Text('say hai '),
                        );
                      }
                  }
                },
              ),
            ),
            _chatinput()
          ],
        ),
      ),
    );
  }

  Widget _appbar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: widget.chatUser.image,
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              )),
          Column(
            children: [
              Text(widget.chatUser.name),
              const Text("last seen not availble")
            ],
          )
        ],
      ),
    );
  }

  Widget _chatinput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.black,
                      )),
                  Expanded(
                      child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration:
                        const InputDecoration(hintText: 'type something'),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera,
                        color: Colors.black,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.black,
                      )),
                  MaterialButton(
                    onPressed: () {},
                    padding: const EdgeInsets.only(left: 3),
                    shape: const CircleBorder(),
                    color: Colors.green,
                    child: const Icon(
                      Icons.send,
                      size: 20,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
