import 'package:flutter/material.dart';
import 'package:stickynotes/db_service.dart';
import 'package:stickynotes/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBService().initializeDatabase();

  runApp(StickyNotes());
}

class StickyNotes extends StatelessWidget {
  const StickyNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
