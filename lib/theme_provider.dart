import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkThemeEnabled = false;

  void updateTheme({required bool isDarkEnabled}) {
    isDarkThemeEnabled = isDarkEnabled;
    notifyListeners();
  }
}
