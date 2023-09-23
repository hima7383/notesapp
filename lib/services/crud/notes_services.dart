import 'package:diaryx/services/crud/crud_exceptions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';

class NotesService {
  Database? _db;
  Future<DatabaseNotes> updateNote(
      {required DatabaseNotes note, required String text}) async {
    final db = _getDataBaseorThrow();
    await getNote(id: note.id);
    final updateCount = await db.update(notesTable, {
      textCol: text,
      isSyncedWithCloudCol: 0,
    });
    if (updateCount == 0) {
      throw CouldNoteUpdateNotes;
    } else {
      return await getNote(id: note.id);
    }
  }

  Future<Iterable<DatabaseNotes>> getAllNotes() async {
    final db = _getDataBaseorThrow();
    final notes = await db.query(
      notesTable,
    );
    return notes.map((noteRow) => DatabaseNotes.fromRow(noteRow));
  }

  Future<DatabaseNotes> getNote({required int id}) async {
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
      return DatabaseNotes.fromRow(notes.first);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDataBaseorThrow();
    return db.delete(notesTable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDataBaseorThrow();
    final deletedCount = await db.delete(
      notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote;
    }
  }

  Future<DatabaseNotes> createNote({required DatabaseUser owner}) async {
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
      isSyncedWithCloudCol: 1,
    });
    final note = DatabaseNotes(
        id: noteid, userID: owner.id, text: text, isSyncedWithCloud: true);
    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
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
  final bool isSyncedWithCloud;

  DatabaseNotes({
    required this.id,
    required this.userID,
    required this.text,
    required this.isSyncedWithCloud,
  });
  DatabaseNotes.fromRow(Map<String, Object?> map)
      : id = map[idCol] as int,
        userID = map[userIdCol] as int,
        text = map[textCol] as String,
        isSyncedWithCloud = map[isSyncedWithCloudCol] as bool;
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
      "is_syced_with_cloud"	INTEGER NOT NULL,
      FOREIGN KEY("user_id") REFERENCES "user"("id"),
      PRIMARY KEY("id" AUTOINCREMENT)
    );''';
