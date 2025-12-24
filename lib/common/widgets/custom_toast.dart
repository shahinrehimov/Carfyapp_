import 'package:flutter/material.dart';

class CustomToast {
  static void showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
