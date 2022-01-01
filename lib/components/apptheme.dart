import 'package:flutter/material.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade300,
    backgroundColor: Colors.grey.shade300,
    appBarTheme: AppBarTheme(
      color: Colors.blue,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    canvasColor: Colors.blue,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      onPrimary: Colors.white,
      secondary: Colors.pink,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    cardColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.blue,
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        color: Colors.black54,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'WorkSans-Regular',
      ),
      headline2: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'WorkSans-Regular',
      ),
      headline3: TextStyle(
        color: Colors.blue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'WorkSans-Regular',
      ),
      headline4: TextStyle(
        color: Colors.black54,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'WorkSans-Regular',
      ),
      subtitle1: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
      subtitle2: TextStyle(
        color: Colors.black45,
        fontSize: 18.0,
      ),
      button: TextStyle(
        color: const Color(0xFFFFFFFF),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      color: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.black,
      secondary: Colors.red,
    ),
    cardTheme: CardTheme(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: TextTheme(
      subtitle1: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
      subtitle2: TextStyle(
        color: Colors.white70,
        fontSize: 18.0,
      ),
    ),
  );
}
