import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwave/api/apis.dart';
import 'package:chatwave/model/chat_user.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final formkey = GlobalKey<FormState>();
String? _image;

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
                _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: Image.file(
                          File(
                            _image!,
                          ),
                          width: 100,
                          height: 100,
                        ),
                      )
                    : ClipRect(
                        child: CachedNetworkImage(
                        imageUrl: widget.user.image,
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill,
                      )),
                Positioned(
                    bottom: 10,
                    left: 45,
                    top: 0,
                    child: MaterialButton(
                      onPressed: () {
                        _showSnakbar();
                      },
                      child:
                          const Icon(Icons.edit, color: Colors.blue, size: 28),
                    )),
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
                            const SnackBar(
                              content: Text('Contents added successfully'),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: const Text("Update"))
            ],
          ),
        ),
      ),
    );
  }

  void _showSnakbar() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 25, bottom: 25),
          children: [
            const Text(
              'take profile picture',
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: const Size(100, 100)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
// Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 90);
                      if (image != null) {
                        log('image :${image.path}, mimtype${image.mimeType},');
                        setState(() {
                          _image = image.path;
                        });
                        Api.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset(
                        'assets/64d1120804fa6_com.sec.android.gallery3d.png')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: const Size(100, 100)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
// Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        log('image :${image.path}, mimtype${image.mimeType},');
                        setState(() {
                          _image = image.path;
                        });
                        Api.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset(
                        'assets/80-801558_transparent-gallery-icon-png-flat-camera-icon-png.png'))
              ],
            )
          ],
        );
      },
    );
  }
}
