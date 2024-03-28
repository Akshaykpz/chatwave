import 'dart:developer';

import 'package:chatwave/api/apis.dart';
import 'package:chatwave/model/chat_user.dart';
import 'package:chatwave/screens/profile_screen.dart';
import 'package:chatwave/screens/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool isSeraching = false;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Api.userInfo();
  }

  @override
  Widget build(BuildContext context) {
    List<ChatUser> list = [];
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () {
          if (isSeraching) {
            setState(() {
              isSeraching != isSeraching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.blue,
          appBar: AppBar(
            leading: const Icon(Icons.home),
            title: const Text('Chat Wave'),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            user: Api.me,
                          ),
                        ));
                  },
                  icon: const Icon(Icons.more))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          body: StreamBuilder(
            stream: Api.getallUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  log("message");
                  if (snapshot.hasData) {
                    final data = snapshot.data!.docs;
                    list =
                        data.map((e) => ChatUser.fromjson(e.data())).toList() ??
                            [];
                  }
                  return ListView.builder(
                      itemCount: list.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          ChatUserCard(user: list[index]));
              }
            },
          ),
        ),
      ),
    );
  }
}
