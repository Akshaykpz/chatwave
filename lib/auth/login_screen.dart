import 'dart:developer';
import 'dart:io';

import 'package:chatwave/api/apis.dart';
import 'package:chatwave/helper/snack_bar.dart';
import 'package:chatwave/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // _handleLoginbutton() {
  //   SnackBars.showprogressBar(context);

  //   _signInWithGoogle().then((user) {
  //     Navigator.pop(context);
  //     if (user != null) {
  //       log('user${user.user}');
  //       log('user detiles:${user.additionalUserInfo}');

  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const HomeScreen(),
  //           ));
  //     }
  //   });
  // }

  _handleGoogleBtnClick() {
    //for showing progress bar
    SnackBars.showprogressBar(context);

    _signInWithGoogle().then((user) async {
      //for hiding progress bar
      Navigator.pop(context);

      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');
        if (await Api.userExit()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await Api.createUser().then(
            (value) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()));
            },
          );
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      SnackBars.showsnackBar(context, 'Something Went Wrong (Check Internet!)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: const Text("Welcome ChatWave"),
      ),
      body: Column(
        children: [
          const Icon(Icons.message),
          ElevatedButton(
              onPressed: () {
                _handleGoogleBtnClick();
              },
              child: const Text('sign in with Google')),
          ElevatedButton(
              onPressed: () {
                Api().signOutFromGoogle();
              },
              child: const Text("sign out"))
        ],
      ),
    );
  }
}
