import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(MentorX());

class MentorX extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
      },
    );
  }
}
