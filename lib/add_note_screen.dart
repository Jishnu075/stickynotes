import 'package:flutter/material.dart';
import 'package:stickynotes/db_service.dart';
import 'package:stickynotes/notes_model.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add your stickie"), centerTitle: false),
      body: SafeArea(
        child: Column(
          children: [
            TextField(decoration: InputDecoration(hintText: "title")),
            TextField(decoration: InputDecoration(hintText: "description")),
            Spacer(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              CloseButton(),
              ElevatedButton(
                  onPressed: () async {
                    final note = Note(
                      id: DateTime.now()
                          .toString(), // Using timestamp as a simple unique ID
                      title: "Mock Title",
                      description: "Mock Description",
                      due: DateTime.now()
                          .add(const Duration(days: 7)), // Due in 7 days
                      lastEdited: DateTime.now(),
                      isFavorite: false,
                      isPinned: false,
                    );

                    // await DBService().insertNote(note);
                    var data = await DBService().retrieveNotes();
                    print(data.first.title);
                    Navigator.pop(context); // Close the screen after adding
                  },
                  child: Text("add")),
            ])
          ],
        ),
      ),
    );
  }
}
