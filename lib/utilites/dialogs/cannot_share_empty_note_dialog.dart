import 'package:diaryx/utilites/dialogs/generic_dialogs.dart';
import 'package:flutter/material.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Sharing",
    content: "You cannot share empty note!",
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
