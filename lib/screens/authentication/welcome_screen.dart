import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/screens/authentication/registration_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key, this.bloc}) : super(key: key);
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
    Provider.of<AuthBase>(context, listen: false);
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
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Colors.grey.shade600,
              kMentorXPPrimary,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 0,
                ),
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset(
                        'assets/images/MentorXP.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 0.0,
            ),
            Container(
              width: 300,
              child: RoundedButton(
                borderRadius: 20,
                title: 'SIGN IN',
                buttonColor: kMentorXPSecondary,
                fontColor: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                onPressed: () => widget._signInWithEmail(context),
                textAlignment: MainAxisAlignment.center,
              ),
            ),
            Container(
              width: 300,
              child: RoundedButton(
                borderRadius: 20,
                title: 'NEW USER',
                buttonColor: Colors.white,
                fontColor: kMentorXPSecondary,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                onPressed: () => widget._createNewUser(context),
                minWidth: 250.0,
                textAlignment: MainAxisAlignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
