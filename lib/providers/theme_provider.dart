import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {

  static bool _isDark = true;
  
  // getters
  bool get isDark => _isDark;

  ThemeProvider();

  static void init(bool? darkMode) {
    _isDark = darkMode ?? true;
  }

  Future<void> toggleDarkMode() async {
    _isDark = !_isDark;
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setBool("isDark#123", _isDark);
    notifyListeners();
  }

}
