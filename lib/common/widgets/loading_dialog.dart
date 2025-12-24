import 'package:flutter/material.dart';

class LoadingDialog {
  static bool _isShowing = false;

  static void show(BuildContext context) {
    if (_isShowing) return;
    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    if (!_isShowing) return;
    _isShowing = false;

    Navigator.of(context, rootNavigator: true).pop();
  }
}
