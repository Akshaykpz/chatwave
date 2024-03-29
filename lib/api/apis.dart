import 'dart:developer';
import 'dart:io';

import 'package:chatwave/model/chat_user.dart';
import 'package:chatwave/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Api {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static late ChatUser me;

  static FirebaseFirestore firebasestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  static Future<bool> userExit() async {
    return (await firebasestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<void> userInfo() async {
    await firebasestore.collection('users').doc(user.uid).get().then(
      (user) async {
        if (user.exists) {
          me = ChatUser.fromjson(user.data()!);
          log('my data ${user.data()}');
        } else {
          await createUser().then(
            (value) => userInfo(),
          );
        }
      },
    );
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatuser = ChatUser(
      id: user.uid,
      name: auth.currentUser!.displayName.toString(),
      email: user.email.toString(),
      about: 'hey am using whatsup',
      createAt: time,
      isonline: false,
      lastactive: time,
      pushtoken: '',
      image: user.photoURL.toString(),
    );
    return (await firebasestore
        .collection('users')
        .doc(user.uid)
        .set(chatuser.toJson()));
  }

  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getallUsers() {
    return firebasestore
        .collection('users')
        .where('id', isEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserinfo() async {
    await firebasestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firebasestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  static String getConversatioId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getallmessages(
      ChatUser user) {
    return firebasestore
        .collection('chats/${getConversatioId(user.id)}/messages/')
        .snapshots();
  }

  static Future<void> sendMessage(
      ChatUser chatuser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
        toid: chatuser.id,
        msg: msg,
        read: '',
        type: type,
        send: time,
        fromid: user.uid);
    final ref = firebasestore
        .collection('chats/${getConversatioId(chatuser.id)}/messages/');
    await ref.doc().set(message.toJson());
  }

  static Future<void> updateMessageStatus(Message message) async {
    firebasestore
        .collection('chats/${getConversatioId(message.fromid)}/messages/')
        .doc(message.send)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
  //     ChatUser user) {
  //   return firebasestore
  //       .collection('chats/${getConversatioId(user.id)}/messages/').orderBy('sent',descending: )
  //       .limit(1)
  //       .snapshots();
  // }

  // static Future<void> sendChatImage(ChatUser chatUser, File file) async {
  //   final ext = file.path.split('.').last;
  //   log('Extension: $ext');

  //   //storage file ref with path
  //   final ref = storage.ref().child(
  //       'images/${getConversatioId(chatUser.id)}${DateTime.now().millisecondsSinceEpoch}.$ext');

  //   //uploading image
  //   await ref
  //       .putFile(file, SettableMetadata(contentType: 'image/$ext'))
  //       .then((p0) {
  //     log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
  //   });

  //   //updating image in firestore database
  //   final imageurl = await ref.getDownloadURL();
  //   await sendMessage(chatUser, imageurl, Type.image);
  // }
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    // Storage file reference with path
    final ref = storage.ref().child(
        'images/${getConversatioId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    // Uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((TaskSnapshot taskSnapshot) async {
      // Getting download URL of the uploaded image
      final imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Creating message object
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final Message message = Message(
          toid: chatUser.id,
          msg: imageUrl, // Sending image URL instead of the file
          read: '',
          type: Type.image,
          send: time,
          fromid: user.uid);

      // Saving message to Firestore
      await firebasestore
          .collection('chats/${getConversatioId(chatUser.id)}/messages/')
          .doc()
          .set(message.toJson());
    }).catchError((error) {
      // Handle errors here
      log('Error uploading image: $error');
    });
  }
}
