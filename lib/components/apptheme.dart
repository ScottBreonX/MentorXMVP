import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: kMentorXPPrimary,
    appBarTheme: AppBarTheme(
      color: kMentorXPPrimary,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    canvasColor: kMentorXPPrimary,
    colorScheme: ColorScheme.light(
      primary: Colors.black54,
      onPrimary: Colors.white,
      secondary: Colors.pink,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    cardColor: Colors.white,
    dividerColor: Colors.grey.shade400,
    iconTheme: IconThemeData(
      color: Colors.blue,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: kMentorXPAccentDark,
        fontSize: 25,
        fontFamily: 'Montserrat',
      ),
      headlineLarge: TextStyle(
        color: Colors.black45,
        fontSize: 25,
        fontFamily: 'Montserrat',
      ),
      headlineMedium: TextStyle(
        color: Colors.black45,
        fontSize: 20,
        fontFamily: 'Montserrat',
      ),
      headlineSmall: TextStyle(
        color: Colors.black45,
        fontSize: 15,
        fontFamily: 'Montserrat',
      ),
      labelLarge: TextStyle(
        color: Colors.black45,
        fontSize: 20,
        fontFamily: 'Montserrat',
      ),
      labelSmall: TextStyle(
        color: Colors.black45,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat',
      ),
      bodyLarge: TextStyle(
        color: Colors.black45,
        fontSize: 15,
        fontFamily: 'Montserrat',
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.black12,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    canvasColor: Colors.grey.shade900.withOpacity(1),
    colorScheme: ColorScheme.dark(
      primary: Colors.white,
      onPrimary: Colors.black54,
      secondary: Colors.white,
    ),
    cardColor: Colors.grey.shade700,
    dividerColor: Colors.grey.shade700,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: kMentorXPAccentDark,
        fontSize: 25,
        fontFamily: 'Montserrat',
      ),
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontFamily: 'Montserrat',
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Montserrat',
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontFamily: 'Montserrat',
      ),
      labelLarge: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Montserrat',
      ),
      labelSmall: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat',
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontFamily: 'Montserrat',
      ),
    ),
  );
}
