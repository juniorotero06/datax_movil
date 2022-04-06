import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void displayDialogAndroid(BuildContext context, String title, String body) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10)),
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(body),
              const SizedBox(height: 10),
              const FlutterLogo(size: 100)
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Ok"))
          ],
        );
      });
}

void displayDialogIOS(BuildContext context, String title, String body) {
  showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(body),
              const SizedBox(height: 10),
              const FlutterLogo(size: 100)
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK")),
          ],
        );
      });
}
