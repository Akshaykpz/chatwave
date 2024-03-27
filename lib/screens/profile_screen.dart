import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwave/api/apis.dart';
import 'package:chatwave/model/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final formkey = GlobalKey<FormState>();

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Api().signOutFromGoogle();
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.red,
        ),
        body: Form(
          key: formkey,
          child: Column(
            children: [
              Stack(children: [
                ClipRect(
                    child: CachedNetworkImage(imageUrl: widget.user.image)),
                MaterialButton(
                  onPressed: () {},
                )
              ]),
              Text(widget.user.email),
              TextFormField(
                onSaved: (newValue) => Api.me.name = newValue ?? "",
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : 'reqired name ',
                initialValue: widget.user.name,
                decoration: InputDecoration(
                    hintText: 'name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              TextFormField(
                initialValue: widget.user.about,
                onSaved: (newValue) => Api.me.about = newValue ?? "",
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : 'reqired about ',
                decoration: InputDecoration(
                    hintText: 'about',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      formkey.currentState!.save();
                      Api.updateUserinfo().then(
                        (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Contents added successfully'),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Text("Update"))
            ],
          ),
        ),
      ),
    );
  }

  void _showSnakbar() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            Text(
              'take profile picture',
              textAlign: TextAlign.center,
            ),
            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: Text("data")),
                ElevatedButton(onPressed: () {}, child: Text(""))
              ],
            )
          ],
        );
      },
    );
  }
}
