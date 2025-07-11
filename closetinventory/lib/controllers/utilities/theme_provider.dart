import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CONSTANTS.primaryLightColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CONSTANTS.primaryDarkColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', _isDarkTheme);
    notifyListeners();
  }
}
