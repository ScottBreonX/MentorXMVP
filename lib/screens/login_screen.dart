import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/services/auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({@required this.auth});
  static const String id = 'login_screen';
  final AuthBase auth;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool showSpinner = false;
  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  void _submit() async {
    setState(() {
      showSpinner = true;
    });
    print(
        'Email: ${_emailController.text} Password: ${_passwordController.text}');
    try {
      await widget.auth.signInWithEmailAndPassword(_email, _password);
      Navigator.of(context).popAndPushNamed(LaunchScreen.id);
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      print(e.toString());
      showAlertDialog(
        context,
        title: "Invalid Credentials",
        content: "Invalid log in credentials. Please try again",
        defaultActionText: "Ok",
      );
    }
    print('Auth is ${widget.auth.currentUser}');
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMentorXTeal,
        title: Text('Log In'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 50,
                ),
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 150.0,
                    child: Image.asset('images/XLogo.png'),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Enter your email',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Enter your password',
                  ),
                ),
                SizedBox(height: 20.0),
                RoundedButton(
                  onPressed: _submit,
                  title: 'LOG IN',
                  color: kMentorXTeal,
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: InkWell(
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(fontSize: 20, color: kMentorXTeal),
                    ),
                    onTap: () {},
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
