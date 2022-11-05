import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key key, this.bloc}) : super(key: key);
  final LoginBloc bloc;
  static const String id = 'reset_password_screen';

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<LoginBloc>(
      create: (_) => LoginBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<LoginBloc>(
        builder: (_, bloc, __) => ResetPasswordScreen(
          bloc: bloc,
        ),
      ),
    );
  }

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 100),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Colors.blue,
              Colors.pink,
            ])),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Column(
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset(
                      'assets/images/MLogoWhite.png',
                      height: 200,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    children: [
                      Text(
                        'Check your email for a password reset link',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Can\'t find the email? Check your junk or spam folders.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Container(),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Container(),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: RoundedButton(
                    textAlignment: MainAxisAlignment.center,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    title: 'Return to log in',
                    buttonColor: kMentorXPrimary,
                    minWidth: 500,
                    fontColor: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
