import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/screens/registration_screen.dart';
import 'package:mentorx_mvp/services/auth_provider.dart';
import 'login_screen.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  void _signInWithEmail(BuildContext context) {
    final auth = AuthProvider.of(context);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => LoginScreen(),
      ),
    );
  }

  void _createNewUser(BuildContext context) {
    final auth = AuthProvider.of(context);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => RegistrationScreen(),
      ),
    );
  }

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
              Colors.white30,
              kMentorXTeal,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 240,
                    child: ColorizeAnimatedTextKit(
                      speed: Duration(milliseconds: 1000),
                      text: ['Mentor'],
                      textStyle: TextStyle(
                        fontSize: 70.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                      colors: [
                        Colors.grey,
                        Colors.white,
                        kMentorXTeal,
                        Colors.white,
                        Colors.grey,
                      ],
                      textAlign: TextAlign.start,
                      alignment: AlignmentDirectional.topStart,
                    ),
                  ),
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/XLogo.png'),
                      height: 100.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              RoundedButton(
                title: 'LOG IN',
                color: kMentorXTeal,
                onPressed: () => widget._signInWithEmail(context),
              ),
              RoundedButton(
                title: 'REGISTER',
                color: kMentorXTeal,
                onPressed: () => widget._createNewUser(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
