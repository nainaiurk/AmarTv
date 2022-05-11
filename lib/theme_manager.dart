// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:live_tv/storage_manager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
      dividerTheme: const DividerThemeData(
        color: Colors.red,
      ),
      //primarySwatch: Colors.grey,
      canvasColor: Colors.black,
      hintColor: Colors.grey,
      accentColorBrightness: Brightness.light,//Used to determine the color of text and icons placed on top of the accent color
      //colorScheme: ColorScheme(),
      primaryColor: Colors.black,//The background color for major parts of the app (toolbars, tab bars, etc)
      brightness: Brightness.dark,
      backgroundColor: const Color(0xFF000000),
      accentColor: Colors.white,//The foreground color for widgets (knobs, text, overscroll edge effect, etc)
      accentIconTheme: const IconThemeData(color: Colors.white),
      dividerColor: Colors.black12,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(color: Colors.white),
      ));

  final lightTheme = ThemeData(
      primarySwatch: Colors.grey,
      dividerTheme: const DividerThemeData(
        color: Colors.red,
      ),
      primaryColor: Colors.white,//The background color for major parts of the app (toolbars, tab bars, etc)
      brightness: Brightness.light,
      canvasColor: Colors.white,
      backgroundColor: const Color(0xFFE5E5E5),
      accentColor: Colors.black,//The foreground color for widgets (knobs, text, overscroll edge effect, etc)
      accentIconTheme: const IconThemeData(color: Colors.white),
      dividerColor: Colors.white,
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black)));

  ThemeData _themeData;

  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      // print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'dark';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } 
      else {
        //print('setting dark theme');
        _themeData = darkTheme;
      }

      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
