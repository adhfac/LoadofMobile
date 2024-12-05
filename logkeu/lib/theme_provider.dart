import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode;

  ThemeProvider({required bool isDarkMode}) : _isDarkMode = isDarkMode;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
