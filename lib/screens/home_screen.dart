import 'dart:developer';

import 'package:chatwave/api/apis.dart';
import 'package:chatwave/model/chat_user.dart';
import 'package:chatwave/screens/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<ChatUser> list = [];
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: const Text('Chat Wave'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: Api.firebasestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              log("message");
              if (snapshot.hasData) {
                final data = snapshot.data!.docs;
                list =
                    data.map((e) => ChatUser.fromjson(e.data())).toList() ?? [];
              }
              return ListView.builder(
                  itemCount: list.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      ChatUserCard(user: list[index]));
          }
        },
      ),
    );
  }
}
