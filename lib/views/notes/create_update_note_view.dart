import 'package:diaryx/services/auth/auth_service.dart';
import 'package:diaryx/utilites/generics/get_Arguments.dart';
import 'package:flutter/material.dart';
import 'package:diaryx/services/crud/notes_services.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNotes? _note;
  late final NotesService _notesService;
  late final TextEditingController _textControler;

  @override
  void initState() {
    _notesService = NotesService();
    _textControler = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textControler.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setipTextControllerListener() {
    _textControler.removeListener(_textControllerListener);
    _textControler.addListener(_textControllerListener);
  }

  //create or update notes

  Future<DatabaseNotes> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<DatabaseNotes>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textControler.text = widgetNote.text;
      return widgetNote;
    }
    final exictingnote = _note;
    if (exictingnote != null) {
      return exictingnote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    final newNote = await _notesService.createNote(owner: owner);
    _note = newNote;
    return newNote;
  }

// if text empty then delete

  void _deletNoteIfTextIsEmpty() {
    final note = _note;
    if (_textControler.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

// automatice save

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textControler.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deletNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff6ae792),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("New Note"),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setipTextControllerListener();
              return TextField(
                controller: _textControler,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Start Typing Here",
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
