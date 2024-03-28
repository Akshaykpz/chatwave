import 'package:chatwave/api/apis.dart';
import 'package:chatwave/model/message.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Api.user.uid == widget.message.fromid
        ? _blueMessage()
        : _greenMessage();
  }

  Widget _blueMessage() {
    return Row(
      children: [
        Container(
          child: Text(widget.message.msg),
        ),
        Text(widget.message.send)
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      children: [
        Container(
          child: Text(widget.message.msg),
        ),
        Text(widget.message.send)
      ],
    );
  }
}
