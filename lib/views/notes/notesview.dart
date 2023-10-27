// ignore_for_file: use_build_context_synchronously

import 'package:diaryx/constants/routs.dart';
import 'package:diaryx/services/auth/auth_service.dart';
import 'package:diaryx/services/auth/bloc/auth_bloc.dart';
import 'package:diaryx/services/auth/bloc/auth_events.dart';
import 'package:diaryx/services/cloud/cloud_note.dart';
import 'package:diaryx/services/cloud/firebase_cloud_storage.dart';
import 'package:diaryx/utilites/dialogs/logout_dialog.dart';
import 'package:diaryx/views/notes/notes_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Popupmenuaction {
  logout;
}

class Notesview extends StatefulWidget {
  const Notesview({super.key});

  @override
  State<Notesview> createState() => _NotesviewState();
}

class _NotesviewState extends State<Notesview> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6ae792),
        title: const Text("Your Notes"),
        actions: [
          PopupMenuButton<Popupmenuaction>(
            onSelected: (value) async {
              switch (value) {
                case Popupmenuaction.logout:
                  final userlogout = await showLogOutDialog(context);
                  if (userlogout) {
                    context.read<AuthBloc>().add(const AuthEventsLogOut());
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<Popupmenuaction>(
                    value: Popupmenuaction.logout, child: Text("logout"))
              ];
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(decumentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context)
                        .pushNamed(createUpdateNoteRoute, arguments: note);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(createUpdateNoteRoute);
        },
        backgroundColor: Colors.white30,
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
    );
  }
}
