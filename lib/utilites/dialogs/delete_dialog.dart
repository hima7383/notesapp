import 'package:diaryx/utilites/dialogs/generic_dialogs.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Delete",
    content: "Are You Sure You Want To Delete",
    optionsBuilder: () => {
      "cancel": false,
      "Delete": true,
    },
  ).then((value) => value ?? false);
}
