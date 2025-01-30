import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickynotes/db_service.dart';
import 'package:stickynotes/screens/home_screen.dart';
import 'package:stickynotes/note_provider.dart';
import 'package:stickynotes/screens/theme_provider.dart';
import 'package:stickynotes/theme.dart';

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
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ],
        builder: (context, snapshot) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.isDarkThemeEnabled
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: HomeScreen(),
          );
        });
  }
}
