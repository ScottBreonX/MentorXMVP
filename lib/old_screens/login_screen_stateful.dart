import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/components/validators.dart';
import 'package:mentorx_mvp/screens/launch_screen.dart';
import 'package:mentorx_mvp/screens/registration_screen_blocbased.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:provider/provider.dart';

class LoginScreenStateful extends StatefulWidget
    with EmailAndPasswordValidators {
  static const String id = 'login_screen_stateful';

  @override
  _LoginScreenStatefulState createState() => _LoginScreenStatefulState();
}

class _LoginScreenStatefulState extends State<LoginScreenStateful> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool showSpinner = false;
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _submitted = false;

  Future<void> _submit() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    setState(() {
      _submitted = true;
      showSpinner = true;
    });
    print(
        'Email: ${_emailController.text} Password: ${_passwordController.text}');
    try {
      await auth.signInWithEmailAndPassword(_email, _password);
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
//    print('Auth is ${widget.auth.currentUser}');
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0;
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password);

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
                _buildEmailTextField(),
                SizedBox(
                  height: 20,
                ),
                _buildPasswordTextField(),
                SizedBox(height: 20.0),
                RoundedButton(
                  onPressed: submitEnabled ? _submit : null,
                  title: 'LOG IN',
                  color: submitEnabled ? kMentorXTeal : Colors.grey,
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: InkWell(
                    child: Text(
                      'Need an account? Register',
                      style: TextStyle(fontSize: 20, color: kMentorXTeal),
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(
                          context, RegistrationScreenBlocBased.id);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      obscureText: true,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.done,
      onChanged: (password) => _submitState(),
      style: TextStyle(
        color: Colors.grey.shade800,
        fontWeight: FontWeight.w400,
      ),
      decoration: kTextFieldDecoration.copyWith(
        labelText: 'Enter your password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
      ),
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: (email) => _submitState(),
      style: TextStyle(
        color: Colors.grey.shade800,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecoration.copyWith(
        labelText: 'Enter your email',
        hintText: 'email@domain.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
      ),
    );
  }

  void _submitState() {
    setState(() {});
  }
}
