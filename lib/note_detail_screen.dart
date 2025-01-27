import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickynotes/add_note_screen.dart';
import 'package:stickynotes/db_service.dart';
import 'package:stickynotes/home_screen.dart';
import 'package:stickynotes/note_provider.dart';
import 'package:stickynotes/notes_model.dart';

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
          backgroundColor: note.colorHEX.isEmpty
              ? Color(int.parse(NoteColors.postItYellow.hexCode))
              : Color(int.parse(note.colorHEX)),
          actions: [
            IconButton(
              onPressed: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Remove'),
                          content: Text('Are you sure?'),
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
              icon: Icon(Icons.delete),
            )
          ],
        ),
        body: Container(
          color: note.colorHEX.isEmpty
              ? Color(int.parse(NoteColors.postItYellow.hexCode))
              : Color(int.parse(note.colorHEX)),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 7,
                  child: Column(children: [
                    TextField(
                      controller: titleTEC,
                    ),
                    TextField(
                      controller: descTEC,
                    ),
                    TextField(
                        controller: dueTEC,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(prefixText: 'days :')),
                  ]),
                ),
                Flexible(
                    flex: 3,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CloseButton(),
                          OutlinedButton(
                            onPressed: () {},
                            child: Text("update"),
                          ),
                          Container(
                              width: 20,
                              height: 20,
                              color: getCardColor(colorHEX: note.colorHEX))
                        ]))
              ],
            ),
          ),
        ));
  }
}
