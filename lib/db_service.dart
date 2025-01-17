import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stickynotes/notes_model.dart';

class DBService {
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
  id TEXT PRIMARY KEY,              
  title TEXT NOT NULL,             
  description TEXT,           
  due INTEGER NOT NULL,             
  lastEdited INTEGER NOT NULL,     
  isFavorite INTEGER NOT NULL,     
  isPinned INTEGER NOT NULL        
);
''');
    }, version: 1);
    return database;
  }

  Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> retrieveNotes() async {
    final db = await database;
    final List<Map<String, Object?>> notesMap = await db.query('notes');
    return [
      for (final {
            'id': id as String,
            'title': title as String,
            'description': description as String?,
            'due': due as int,
            'lastEdited': lastEdited as int,
            'isFavorite': isFavorite as int,
            'isPinned': isPinned as int,
          } in notesMap)
        Note(
          id: id,
          title: title,
          description: description,
          due: DateTime(due),
          lastEdited: DateTime(lastEdited),
          isFavorite: isFavorite == 1,
          isPinned: isPinned == 1,
        ),
    ];
  }
}
