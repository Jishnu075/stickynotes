import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickynotes/screens/add_note_screen.dart';
import 'package:stickynotes/db_service.dart';
import 'package:stickynotes/screens/home_screen.dart';
import 'package:stickynotes/note_provider.dart';
import 'package:stickynotes/notes_model.dart';
import 'package:stickynotes/widgets/minimal_text_field.dart';

class NoteDetailScreen extends StatelessWidget {
  NoteDetailScreen({
    super.key,
    required this.note,
  });
  final Note note;
  final TextEditingController titleTEC = TextEditingController();
  final TextEditingController descTEC = TextEditingController();
  final TextEditingController dueTEC = TextEditingController();
  final FocusNode titleFN = FocusNode();
  int _getDaysUntil(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    final days = difference.inDays;
    return days;
  }

  @override
  Widget build(BuildContext context) {
    titleTEC.text = note.title;
    descTEC.text = note.description ?? "";
    dueTEC.text = (_getDaysUntil(note.due) + 1).toString();

    return Scaffold(
        appBar: AppBar(
          title: const Text('detail'),
          centerTitle: false,
          backgroundColor: note.colorHEX.isEmpty
              ? Color(int.parse(NoteColors.postItYellow.hexCode))
              : Color(int.parse(note.colorHEX)),
          actions: [
            IconButton(
              onPressed: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Remove'),
                          content: const Text('Are you sure?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.maybePop(context),
                                child: const Text('cancel')),
                            TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(12, 244, 67, 54),
                                    foregroundColor: Colors.redAccent),
                                onPressed: () async {
                                  await DBService().deleteNote(note);
                                  if (context.mounted) {
                                    Provider.of<NoteProvider>(context,
                                            listen: false)
                                        .fetchNotes();
                                    Navigator.pop(context);
                                    Navigator.maybePop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('note deleted')));
                                  }
                                },
                                child: const Text('delete'))
                          ],
                        ));
              },
              icon: const Icon(Icons.delete),
            )
          ],
        ),
        body: Container(
          color: note.colorHEX.isEmpty
              ? Color(int.parse(NoteColors.postItYellow.hexCode))
              : Color(int.parse(note.colorHEX)),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 7,
                    child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MinimalTextField(
                            controller: titleTEC,
                            prefixText: 'title: ',
                          ),
                          const SizedBox(height: 10),
                          MinimalTextField(
                            controller: descTEC,
                            maxLines: null,
                            prefixText: 'description: ',
                          ),
                          const SizedBox(height: 10),
                          MinimalTextField(
                              prefixText: 'days: ',
                              controller: dueTEC,
                              keyboardType: TextInputType.number),
                        ]),
                  ),
                  Flexible(
                      flex: 3,
                      child: Row(children: [
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () async {
                            final editedNote = Note(
                                id: note.id,
                                title: titleTEC.text,
                                description: descTEC.text,
                                due: DateTime.now().add(
                                    Duration(days: int.parse(dueTEC.text))),
                                lastEdited: DateTime.now(),
                                isFavorite: false,
                                isPinned: note.isPinned,
                                colorHEX: note.colorHEX);
                            await DBService().updateNote(editedNote);
                            if (context.mounted) {
                              Provider.of<NoteProvider>(context, listen: false)
                                  .fetchNotes();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('updated')));
                            }
                          },
                          child: const Text("update"),
                        ),
                        Container(
                            width: 20,
                            height: 20,
                            color: getCardColor(colorHEX: note.colorHEX))
                      ]))
                ],
              ),
            ),
          ),
        ));
  }
}
