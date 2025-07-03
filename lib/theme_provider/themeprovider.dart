// ignore_for_file: unused_import, prefer_final_fields, unused_field

import 'package:flutter/material.dart';
class Themeprovider with ChangeNotifier{
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  void toggle_theme()
  {
    _themeMode = _themeMode==ThemeMode.light?ThemeMode.dark:ThemeMode.light;
    notifyListeners();
  }
}