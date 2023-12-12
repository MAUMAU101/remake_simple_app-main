import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
    primaryColor: mainColor,
    hintColor: fontColor,
    colorScheme: const ColorScheme(
      background: tealColor,
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 42, 171, 89),
      onPrimary: Colors.white,
      secondary: Color.fromARGB(255, 99, 54, 110),
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      onBackground: Colors.black,
      surface: Colors.grey,
      onSurface: Colors.black,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
      ),
    ),
  );

  static const Color mainColor = Color.fromARGB(255, 91, 20, 130);
  static const Color fontColor = Color.fromARGB(255, 0, 0, 0);
  static const Color tealColor = Colors.teal;

  static Color get backgroundColor => themeData.colorScheme.background;
}
