import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stickynotes/db_service.dart';
import 'package:stickynotes/note_provider.dart';
import 'package:stickynotes/notes_model.dart';
import 'package:stickynotes/widgets/color_picker_dropdown.dart';
import 'package:stickynotes/screens/home_screen.dart';
import 'package:stickynotes/widgets/minimal_text_field.dart';

enum NoteColors {
  // lemonChiffon("0xFFFFF9B1"),
  // paleGreen("0xFFDAF7A1"),
  // pastelGreen("0xFFC9DF56"),
  // seafoam("0xFFB6D7A8"),
  // skyBlue("0xFF6ED8FA"),
  // powderBlue("0xFFB1D3F6"),
  // gold("0xFFFFC000"),
  // periwinkle("0xFF8CA0FF");

  // softCream("0xffFDF5E6"),
  // paleSage("0xffE8EDED"),
  // lightLavender("0xffF3E5F5"),
  // coolGrey("0xffF5F5F5"),
  // shellPink("0xffFFF0F0"),
  // paperWhite("0xffFAFAFA"),
  // cornSilk("0xFF99FFFF");
  postItYellow("0xFFFFE44D"), // The classic, most recommended default
  softMint("0xFF98FFB3"), // A gentle but noticeable green
  calmBlue("0xFF99E6FF"), // Fresh sky blue
  warmPeach("0xFFFFB399"), // Soft orangey peach
  gentlePink("0xFFFFB3B3"), // Light warm pink
  lavenderMist("0xFFE6B3FF"), // Soft purple
  paleApricot("0xFFFFCC99"), // Light orange
  freshMint("0xFFB3FFB3"), // Slightly brighter mint
  softSalmon("0xFFFF9999"); // Coral-like tone

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
  const AddNoteScreen({super.key});

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
  Color screenColor = getCardColor(colorHEX: NoteColors.postItYellow.hexCode);
  NoteColors selectedDropDownColor = NoteColors.postItYellow;
  // bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add your stickie"),
        centerTitle: false,
        // backgroundColor: screenColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 7,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MinimalTextField(
                        controller: titleTextEditingController,
                        hintText: 'title',
                      ),
                      const SizedBox(height: 10),
                      MinimalTextField(
                        controller: descTextEditingController,
                        hintText: 'description',
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            const Text('pin it?'),
                            const SizedBox(width: 10),
                            Switch.adaptive(
                                value: isPinned,
                                onChanged: (value) {
                                  setState(() {
                                    isPinned = value;
                                  });
                                })
                          ])),
                      MinimalTextField(
                        controller: dueTextEditingController,
                        hintText: 'to be done in how many days?',
                        keyboardType: TextInputType.number,
                      ),
                      // DropdownMenu(
                      //   initialSelection: NoteColors.postItYellow,
                      //   onSelected: (value) {
                      //     colorHEXcode = value?.hexCode ?? "";
                      //     setState(() {
                      //       screenColor =
                      //           getCardColor(colorHEX: value?.hexCode ?? "");
                      //     });
                      //   },
                      //   dropdownMenuEntries: [
                      //     // for (var color in NoteColors.values)
                      //     //   DropdownMenuEntry(
                      //     //     value: color,
                      //     //     label: color.name,
                      //     //   ),
                      //     DropdownMenuEntry(
                      //         label: 'pinkkk',
                      //         value: NoteColors.postItYellow,
                      //         labelWidget: CircleAvatar())
                      //   ],
                      // ),
                      const SizedBox(height: 10),
                      ColorPickerDropdown(
                          selectedColor: selectedDropDownColor,
                          onColorSelected: (NoteColors color) {
                            colorHEXcode = color.hexCode;
                            setState(() {
                              screenColor =
                                  getCardColor(colorHEX: color.hexCode);
                              selectedDropDownColor = color;
                            });
                          })
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
                                  HapticFeedback.lightImpact();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('added')));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'title and due must be filled')));
                              }
                            },
                            child: const Text("add")),
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}
