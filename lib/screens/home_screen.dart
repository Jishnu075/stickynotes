import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickynotes/screens/add_note_screen.dart';
import 'package:stickynotes/screens/note_detail_screen.dart';
import 'package:stickynotes/note_provider.dart';
import 'package:stickynotes/notes_model.dart';
import 'package:stickynotes/widgets/sticky_note_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        titleSpacing: 20,
        title: const Text(
          style: TextStyle(fontWeight: FontWeight.w200),
          "Sticky Notes",
        ),
        centerTitle: false,
        forceMaterialTransparency: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddNoteScreen()));
          },
          child: const Icon(Icons.add)),
      body: noteProvider.notes.isEmpty
          ? const Center(child: Text("add some!"))
          : RefreshIndicator.adaptive(
              onRefresh: () {
                return noteProvider.fetchNotes();
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: noteProvider.notes.length,
                  itemBuilder: (context, index) {
                    final Note note = noteProvider.notes[index];
                    return StickyNoteCard(
                      title: note.title,
                      description: note.description ?? "",
                      dueDate: note.due,
                      isPinned: note.isPinned,
                      backgroundColor: getCardColor(colorHEX: note.colorHEX),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoteDetailScreen(
                                    note: noteProvider.notes[index])));
                      },
                    );
                  },
                ),
              ),
            ),
    );
  }
}

Color getCardColor({required String colorHEX}) {
  if (colorHEX.isEmpty) {
    return Color(int.parse(NoteColors.postItYellow.hexCode));
  }
  return Color(int.parse(colorHEX));
}
