import 'package:cached_network_image/cached_network_image.dart';

import 'package:chatwave/model/chat_user.dart';

import 'package:chatwave/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

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
          child: ListTile(
            title: Text(widget.user.name),
            leading: SizedBox(
                height: 50,
                width: 50,
                child: CachedNetworkImage(imageUrl: widget.user.image)),
            subtitle: Text(
              widget.user.about,
              maxLines: 1,
            ),
            trailing: const Text('12 pm'),
          ),
        ));
  }
}
