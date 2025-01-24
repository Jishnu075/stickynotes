import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stickynotes/notes_model.dart';

class DBService {
  final String notesTable = 'notes';
  static Database? _db;
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initializeDatabase();
    return _db!;
  }

  //init
  Future<Database> initializeDatabase() async {
    final database = openDatabase(join(await getDatabasesPath(), 'notes.db'),
        onCreate: (db, version) {
      return db.execute('''
CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,              
  title TEXT NOT NULL,             
  description TEXT,           
  due INTEGER NOT NULL,             
  lastEdited INTEGER NOT NULL,     
  isFavorite INTEGER NOT NULL,     
  isPinned INTEGER NOT NULL,
  colorHEX TEXT
);
''');
    }, version: 1);
    return database;
  }

  Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert(
      notesTable,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> retrieveNotes() async {
    final db = await database;
    final List<Map<String, Object?>> notesMap = await db.query(notesTable);
    return [
      for (final {
            'id': id as int,
            'title': title as String,
            'description': description as String?,
            'due': due as int,
            'lastEdited': lastEdited as int,
            'isFavorite': isFavorite as int,
            'isPinned': isPinned as int,
            'colorHEX': colorHEX as String,
          } in notesMap)
        Note(
          id: id,
          title: title,
          description: description,
          due: DateTime.fromMillisecondsSinceEpoch(due),
          lastEdited: DateTime.fromMillisecondsSinceEpoch(lastEdited),
          isFavorite: isFavorite == 1,
          isPinned: isPinned == 1,
          colorHEX: colorHEX,
        ),
    ];
  }

  Future<void> deleteNote(Note note) async {
    final db = await database;
    await db.delete(
      notesTable,
      where: 'id = ${note.id}',
    );
  }

  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update(
      notesTable,
      note.toMap(),
      where: 'id = ${note.id}',
    );
  }
}
