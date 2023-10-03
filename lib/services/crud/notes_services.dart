import 'dart:async';
import 'package:diaryx/extensions/lists/filter.dart';
import 'package:diaryx/services/crud/crud_exceptions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';

class NotesService {
  DatabaseUser? _user;

  Database? _db;

  List<DatabaseNotes> _notes = [];

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance() {
    _notesStreamController =
        StreamController<List<DatabaseNotes>>.broadcast(onListen: () {
      _notesStreamController.sink.add(_notes);
    });
  }
  factory NotesService() => _shared;

  late final StreamController<List<DatabaseNotes>> _notesStreamController;

  Stream<List<DatabaseNotes>> get allNotes =>
      _notesStreamController.stream.filter(
        (note) {
          final currrentuser = _user;
          if (currrentuser != null) {
            return note.userID == currrentuser.id;
          } else {
            throw UserShouldBeSetBeForeReadingAllNotes();
          }
        },
      );

  Future<DatabaseUser> getOrCreateUser({
    required String email,
    bool setAsCurrentUser = true,
  }) async {
    try {
      final user = await getUser(email: email);
      if (setAsCurrentUser) {
        _user = user;
      }
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      if (setAsCurrentUser) {
        _user = createdUser;
      }
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cachNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Future<DatabaseNotes> updateNote(
      {required DatabaseNotes note, required String text}) async {
    await _ensureDbIsOpen();
    final db = _getDataBaseorThrow();
    await getNote(id: note.id);
    final updateCount = await db.update(
        notesTable,
        {
          textCol: text,
        },
        where: 'id = ?',
        whereArgs: [note.id]);
    if (updateCount == 0) {
      throw CouldNoteUpdateNotes;
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  Future<Iterable<DatabaseNotes>> getAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDataBaseorThrow();
    final notes = await db.query(
      notesTable,
    );
    return notes.map((noteRow) => DatabaseNotes.fromRow(noteRow));
  }

  Future<DatabaseNotes> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDataBaseorThrow();
    final notes = await db.query(
      notesTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNoteFindNote;
    } else {
      final note = DatabaseNotes.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDataBaseorThrow();
    _notes = [];
    _notesStreamController.add(_notes);
    return db.delete(notesTable);
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDataBaseorThrow();
    final deletedCount = await db.delete(
      notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote;
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<DatabaseNotes> createNote({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDataBaseorThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    const text = '';
    // create notes
    final noteid = await db.insert(notesTable, {
      userIdCol: owner.id,
      textCol: text,
    });
    final note = DatabaseNotes(
      id: noteid,
      userID: owner.id,
      text: text,
    );
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDataBaseorThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDataBaseorThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userID = await db.insert(userTable, {emailCol: email.toLowerCase()});
    return DatabaseUser(id: userID, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDataBaseorThrow();
    final deletCount = await db.delete(
      userTable,
      where: 'email= ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDataBaseorThrow() {
    final dp = _db;
    if (dp == null) {
      throw DatabaseIsNotOpened();
    } else {
      return dp;
    }
  }

  Future<void> close() async {
    final dp = _db;
    if (dp == null) {
      throw DatabaseIsNotOpened();
    } else {
      await dp.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      //don't do anything
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();

      final dppath = join(docsPath.path, dpName);

      final dp = await openDatabase(dppath);

      _db = dp;

      await dp.execute(createUser1);

      await dp.execute(createnote);
      await _cachNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({required this.id, required this.email});
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idCol] as int,
        email = map[emailCol] as String;
  @override
  String toString() {
    return 'Person, ID = $id , Email = $email';
  }

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNotes {
  final int id;
  final int userID;
  final String text;

  DatabaseNotes({
    required this.id,
    required this.userID,
    required this.text,
  });
  DatabaseNotes.fromRow(Map<String, Object?> map)
      : id = map[idCol] as int,
        userID = map[userIdCol] as int,
        text = map[textCol] as String;
  //isSyncedWithCloud = map[isSyncedWithCloudCol] as bool;
  @override
  String toString() {
    return 'Notes, id = $id , Userid = $userID';
  }

  @override
  bool operator ==(covariant DatabaseNotes other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dpName = 'notes.db';
const notesTable = 'notes';
const userTable = 'user';
const idCol = 'id';
const emailCol = 'email';
const userIdCol = 'user_id';
const textCol = 'text';
const isSyncedWithCloudCol = 'is_syced_with_cloud';
const createUser1 = '''CREATE TABLE IF NOT EXISTS "user" (
      "id"	INTEGER NOT NULL,
      "email"	TEXT NOT NULL UNIQUE,
      PRIMARY KEY("id" AUTOINCREMENT)
    );''';
const createnote = '''CREATE TABLE IF NOT EXISTS "notes" (
      "id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	FOREIGN KEY("user_id") REFERENCES "user"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)
    );''';
