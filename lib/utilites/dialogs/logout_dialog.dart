import 'package:diaryx/utilites/dialogs/generic_dialogs.dart';
import 'package:flutter/material.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Log Out",
    content: "Are You Sure You Want To Logout",
    optionsBuilder: () => {
      "cancel": false,
      "Logout": true,
    },
  ).then((value) => value ?? false);
}
