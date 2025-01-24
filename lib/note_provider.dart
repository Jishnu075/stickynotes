import 'package:flutter/material.dart';
import 'package:stickynotes/notes_model.dart';
import 'package:stickynotes/db_service.dart';

class NoteProvider extends ChangeNotifier {
  final List<Note> notes = [];
  final DBService _dbService = DBService();
  NoteProvider() {
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await _dbService.retrieveNotes();
    notes.clear();
    notes.addAll(fetchedNotes);
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _dbService.insertNote(note);
    await fetchNotes();
  }
}
