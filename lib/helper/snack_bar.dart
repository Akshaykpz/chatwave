import 'package:flutter/material.dart';

class SnackBars {
  static void showsnackBar(BuildContext context, String data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(data),
      backgroundColor: Colors.white.withOpacity(.6),
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showprogressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(child: const CircularProgressIndicator()),
    );
  }
}
