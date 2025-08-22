import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Toast {
  static void showToast(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final toast = Toastification();
    toast.show(
      context: context,
      title: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),

      backgroundColor: isError
          ? Colors.red
          : Colors.green,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(
        seconds: 2,
      ),
    );
  }
}
