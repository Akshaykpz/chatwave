import 'package:chatwave/model/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Api {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firebasestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;
  static Future<bool> userExit() async {
    return (await firebasestore.collection('users').doc(user.uid).get()).exists;
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
}
