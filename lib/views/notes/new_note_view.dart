import 'package:flutter/material.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("New Note"),
      ),
      body: const Text("write your note"),
    );
  }
}
