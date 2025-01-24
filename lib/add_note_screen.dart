import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickynotes/db_service.dart';
import 'package:stickynotes/note_provider.dart';
import 'package:stickynotes/notes_model.dart';

enum NoteColors {
  lemonChiffon("0xFFFFF9B1"),
  paleGreen("0xFFDAF7A1"),
  pastelGreen("0xFFC9DF56"),
  seafoam("0xFFB6D7A8"),
  skyBlue("0xFF6ED8FA"),
  powderBlue("0xFFB1D3F6"),
  gold("0xFFFFC000"),
  periwinkle("0xFF8CA0FF");

  final String hexCode;

  const NoteColors(this.hexCode);
}

// #F5F6F8 - Ghost White
// #FFF9B1 - Lemon Chiffon
// #DAF7A1 - Pale Green
// #FFC000 - Gold
// #C9DF56 - Pastel Green
// #FF9D48 - Apricot
// #B6D7A8 - Seafoam
// #FF0000 - Red
// #77CCC7 - Turquoise
// #ECA2C4 - Carnation Pink
// #6ED8FA - Sky Blue
// #FFCEE0 - Pale Pink
// #B1D3F6 - Powder Blue
// #B485BC - Wisteria
// #8CA0FF - Periwinkle
// #000000 - Black
class AddNoteScreen extends StatefulWidget {
  AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleTextEditingController =
      TextEditingController();

  final TextEditingController descTextEditingController =
      TextEditingController();
  final TextEditingController dueTextEditingController =
      TextEditingController();
  bool isPinned = false;
  String colorHEXcode = '';
  // bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add your stickie"), centerTitle: false),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 7,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: titleTextEditingController,
                      decoration: InputDecoration(hintText: "title"),
                    ),
                    TextField(
                      controller: descTextEditingController,
                      decoration: InputDecoration(hintText: "description"),
                    ),
                    Row(children: [
                      const Text('pin ?'),
                      Switch.adaptive(
                          value: isPinned,
                          onChanged: (value) {
                            setState(() {
                              isPinned = value;
                            });
                          })
                    ]),
                    TextField(
                      controller: dueTextEditingController,
                      decoration: InputDecoration(hintText: 'days?'),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                    ),
                    DropdownMenu(
                      initialSelection: NoteColors.gold,
                      onSelected: (value) {
                        colorHEXcode = value?.hexCode ?? "";
                      },
                      dropdownMenuEntries: [
                        for (var color in NoteColors.values)
                          DropdownMenuEntry(
                            value: color,
                            label: color.name,
                          ),
                      ],
                    ),
                    // DateRangePickerDialog(
                    //     initialEntryMode: DatePickerEntryMode.calendarOnly,
                    //     helpText: 'due',
                    //     firstDate: DateTime.now(),
                    //     lastDate: DateTime.now().add(const Duration(days: 200))),
                  ],
                ),
              ),
            ),
            Flexible(
                flex: 3,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const CloseButton(),
                      ElevatedButton(
                          onPressed: () async {
                            if (titleTextEditingController.text.isNotEmpty &&
                                descTextEditingController.text.isNotEmpty &&
                                dueTextEditingController.text.isNotEmpty) {
                              final note = Note(
                                title: titleTextEditingController.text,
                                description: descTextEditingController.text,
                                due: DateTime.now().add(Duration(
                                    days: int.parse(
                                        dueTextEditingController.text))),
                                lastEdited: DateTime.now(),
                                isFavorite: false,
                                isPinned: isPinned,
                                colorHEX: colorHEXcode,
                              );
                              await DBService().insertNote(note);
                              if (context.mounted) {
                                Provider.of<NoteProvider>(context,
                                        listen: false)
                                    .fetchNotes();
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('added')));
                              }
                            }
                          },
                          child: Text("add")),
                    ]))
          ],
        ),
      ),
    );
  }
}
