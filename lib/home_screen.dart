import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickynotes/add_note_screen.dart';
import 'package:stickynotes/note_detail_screen.dart';
import 'package:stickynotes/note_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Sticky Notes"), centerTitle: false, actions: [
        IconButton(onPressed: () async {}, icon: const Icon(Icons.menu))
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddNoteScreen()));
          },
          child: const Icon(Icons.add)),
      body: noteProvider.notes.length == 0
          ? Center(child: Text("add some!"))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: noteProvider.notes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NoteDetailScreen(
                                note: noteProvider.notes[index])));
                  },
                  child: Container(
                      color: getCardColor(
                          colorHEX: noteProvider.notes[index].colorHEX),
                      child: Column(children: [
                        Text(noteProvider.notes[index].title),
                        Text(noteProvider.notes[index].description ?? ""),
                        Text("${noteProvider.notes[index].due}")
                      ])),
                );
              },
              // crossAxisCount: 2,
              // crossAxisSpacing: 5,
              // mainAxisSpacing: 5,
            ),
    );
  }
}

Color getCardColor({required String colorHEX}) {
  if (colorHEX.isEmpty) return Color(int.parse(NoteColors.gold.hexCode));
  return Color(int.parse(colorHEX));
}
