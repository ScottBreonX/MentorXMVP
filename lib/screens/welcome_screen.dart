import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/screens/registration_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key, @required this.bloc}) : super(key: key);
  final LoginBloc bloc;
  static const String id = 'welcome_screen';

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<LoginBloc>(
      create: (_) => LoginBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<LoginBloc>(
        builder: (_, bloc, __) => WelcomeScreen(bloc: bloc),
      ),
    );
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => LoginScreenBlocBased.create(context),
      ),
    );
  }

  void _createNewUser(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => RegistrationScreen.create(context),
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
  void didChangeDependencies() {
    precacheImage(AssetImage('images/XMountains.jpg'), context);
    super.didChangeDependencies();
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
          image: DecorationImage(
            image: AssetImage("images/XMountains.jpg"),
            fit: BoxFit.cover,
          ),
//          gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//            colors: [
//              Colors.white,
//              Colors.white,
//              Colors.white30,
//              kMentorXTeal,
//            ],
//          ),
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
                        color: Colors.white,
                      ),
                      colors: [
                        Colors.white,
                        Colors.white60,
                        Colors.grey,
                        kMentorXTeal,
                        Colors.grey,
                        Colors.white60,
                        Colors.white,
//                        Colors.grey,
//                        Colors.white,
//                        kMentorXTeal,
//                        Colors.white,
//                        Colors.grey,
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
                height: 200.0,
              ),
              RoundedButton(
                title: 'Sign up',
                buttonColor: kMentorXTeal,
                fontColor: Colors.white,
                onPressed: () => widget._createNewUser(context),
                minWidth: 250.0,
              ),
              RoundedButton(
                title: 'Sign in',
                buttonColor: Colors.white,
                fontColor: kMentorXTeal,
                onPressed: () => widget._signInWithEmail(context),
                minWidth: 250.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
