import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickynotes/db_service.dart';
import 'package:stickynotes/screens/home_screen.dart';
import 'package:stickynotes/note_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBService().initializeDatabase();
  runApp(const StickyNotes());
}

class StickyNotes extends StatelessWidget {
  const StickyNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NoteProvider()),
        ],
        builder: (context, snapshot) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          );
        });
  }
}
