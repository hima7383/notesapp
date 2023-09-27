import 'package:diaryx/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:diaryx/services/crud/notes_services.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
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

  Future<DatabaseNotes> createNewNote() async {
    final exictingnote = _note;
    if (exictingnote != null) {
      return exictingnote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
  }

  void _deletNoteIfTextIsEmpty() {
    final note = _note;
    if (_textControler.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("New Note"),
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNotes;
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
