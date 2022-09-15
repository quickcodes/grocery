import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showPopupDialog(
  BuildContext context,
  String title,
  String content,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"))
        ],
      );
    },
  );
}
