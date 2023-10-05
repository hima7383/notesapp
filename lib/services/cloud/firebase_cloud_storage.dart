import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryx/services/cloud/cloud_note.dart';
import 'package:diaryx/services/cloud/cloud_storage_constants.dart';
import 'package:diaryx/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection("notes");

  Future<void> deleteNote({required String decumentId}) async {
    try {
      await notes.doc(decumentId).delete();
    } catch (e) {
      CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNotes(
      {required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({textFeildName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return notes.snapshots().map((event) => event.docs
        .map((doc) => CloudNote.fromSnapshot(doc))
        .where((element) => element.ownerUserId == ownerUserId));
  }

  Future<Iterable<CloudNote>> getnotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((value) => value.docs.map((docs) {
                return CloudNote(
                  documentId: docs.id,
                  ownerUserId: docs.data()[ownerUserIdFieldName] as String,
                  text: docs.data()[textFeildName] as String,
                );
              }));
    } catch (e) {
      throw CouldNotGetNoteException();
    }
  }

  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFeildName: '',
    });
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
