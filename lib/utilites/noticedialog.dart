import 'package:flutter/material.dart';

Future<void> showWindow(BuildContext context, String txt, String label) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(label),
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
