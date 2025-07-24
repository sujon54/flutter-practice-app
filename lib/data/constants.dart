import 'package:flutter/material.dart';

class KConstants{
  static const String themeModeKey = "themeModeKey";
  static const baseUrl = 'http://192.168.0.129:8000/api';
}

class KTextStyles{
  static const TextStyle titleTealText = TextStyle(
    color: Colors.teal,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );
}

class KValues {
  static const String appName = "First Flutter App";
  static const String welcomeMessage = "Welcome to the First Flutter App!";
  static const String loginButtonText = "Login";
  static const String registerButtonText = "Register";
  static const String getStartedButtonText = "Get Started";
}