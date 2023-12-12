import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    primaryColor: Colors
        .transparent, // Use transparent to allow the gradient to be visible
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide.none,
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: Colors.transparent,
    ),
  );

  static const Color mainColor = Color.fromARGB(255, 33, 243, 173);
  static const Color fontColor = Color.fromARGB(255, 16, 15, 16);

  static BoxDecoration gradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomRight,
        colors: [
          Color.fromARGB(255, 33, 243, 173),
          Color.fromARGB(255, 97, 91, 75),
        ],
      ),
    );
  }
}
