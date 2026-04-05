import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CustomToast {
  static void showToast(
    BuildContext context,
    String message, {
    ToastificationType type = ToastificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topCenter,
      autoCloseDuration: duration,
      title: Text(message),
      showProgressBar: false,
      dragToClose: true,
      closeOnClick: true,
      applyBlurEffect: true,
    );
  }

  static void showSuccess(BuildContext context, String message) =>
      showToast(context, message, type: ToastificationType.success);

  static void showError(BuildContext context, String message) =>
      showToast(context, message, type: ToastificationType.error);
}
