import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwave/api/apis.dart';
import 'package:chatwave/model/chat_user.dart';
import 'package:chatwave/model/message.dart';
import 'package:chatwave/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

Message? _message;

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    chatUser: widget.user,
                  ),
                ));
          },
          child: StreamBuilder(
            stream: Api.getLastMessages(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data!.docs;
              final list =
                  data!.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) _message = list[0];
              return ListTile(
                title: Text(widget.user.name),
                leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: CachedNetworkImage(imageUrl: widget.user.image)),
                subtitle: Text(
                  _message != null ? _message!.msg : widget.user.about,
                  maxLines: 1,
                ),
                trailing: const Text('12 pm'),
              );
            },
          )),
    );
  }
}
