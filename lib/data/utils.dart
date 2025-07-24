import 'package:flutter/material.dart';

class Utils {
  static void showError(String message, context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
