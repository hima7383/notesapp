import 'package:flutter/material.dart';

Future<void> showError(BuildContext context, String txt) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error has occured"),
          content: Text(txt),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"))
          ],
        );
      });
}
