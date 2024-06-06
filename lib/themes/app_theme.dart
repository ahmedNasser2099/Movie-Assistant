import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
        titleLarge: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        toolbarTextStyle: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
        ).bodyMedium,
        titleTextStyle: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
        ).titleLarge,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.blue,
        textTheme: ButtonTextTheme.primary,
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
          .copyWith(surface: Colors.white),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
        titleLarge: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarTextStyle: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
        ).bodyMedium,
        titleTextStyle: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
        ).titleLarge,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.blue,
        textTheme: ButtonTextTheme.primary,
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
          .copyWith(surface: Colors.black),
    );
  }
}
