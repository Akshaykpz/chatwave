import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwave/api/apis.dart';
import 'package:chatwave/model/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Api().signOutFromGoogle();
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          ClipRect(child: CachedNetworkImage(imageUrl: widget.user.image)),
          Text(widget.user.email),
          TextFormField(
            initialValue: widget.user.name,
            decoration: InputDecoration(
                hintText: 'name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
          TextFormField(
            initialValue: widget.user.name,
            decoration: InputDecoration(
                hintText: 'about',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
          ElevatedButton(onPressed: () {}, child: Text("Update"))
        ],
      ),
    );
  }
}
