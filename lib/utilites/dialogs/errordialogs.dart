import 'package:diaryx/utilites/dialogs/generic_dialogs.dart';
import 'package:flutter/material.dart';

Future<void> showError(BuildContext context, String txt) {
  return showGenericDialog(
    context: context,
    title: 'An eror has occured',
    content: txt,
    optionsBuilder: () => {
      'OK': Null,
    },
  );
}
