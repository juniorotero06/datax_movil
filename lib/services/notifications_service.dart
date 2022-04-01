import 'package:flutter/material.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    ));
  }
}
