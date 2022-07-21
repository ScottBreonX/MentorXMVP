import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/models/login_model.dart';
import 'package:mentorx_mvp/screens/authentication/landing_page.dart';
import 'package:mentorx_mvp/screens/authentication/verify_email_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:provider/provider.dart';

import 'forgot_password_screen.dart';

class LoginScreenBlocBased extends StatefulWidget {
  const LoginScreenBlocBased({Key key, @required this.bloc}) : super(key: key);
  final LoginBloc bloc;
  static const String id = 'login_screen_blocbased';

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<LoginBloc>(
      create: (_) => LoginBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<LoginBloc>(
        builder: (_, bloc, __) => LoginScreenBlocBased(bloc: bloc),
      ),
    );
  }

  void _forgotPassword(BuildContext context) {
    Provider.of<AuthBase>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => ForgotPasswordScreen.create(context),
      ),
    );
  }

  @override
  _LoginScreenBlocBasedState createState() => _LoginScreenBlocBasedState();
}

class _LoginScreenBlocBasedState extends State<LoginScreenBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isEmailVerified = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;
    });
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      await checkEmailVerified();
      isEmailVerified
          ? Navigator.of(context).popAndPushNamed(LandingPage.id)
          : Navigator.of(context).popAndPushNamed(VerifyEmailScreen.id);
    } catch (e) {
      showAlertDialog(
        context,
        title: "Invalid Credentials",
        content: "Invalid log in credentials. Please try again",
        defaultActionText: "Ok",
      );
    }
  }

  TextField _buildEmailTextField(LoginModel model) {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: widget.bloc.updateEmail,
      style: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w600,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        prefixIcon: Icon(Icons.email),
        labelText: 'Email',
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        hintText: 'email@domain.com',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 4.0),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
      ),
    );
  }

  TextField _buildPasswordTextField(LoginModel model) {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.done,
      onChanged: widget.bloc.updatePassword,
      style: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w600,
      ),
      decoration: kTextFieldDecorationLight.copyWith(
        prefixIcon: Icon(Icons.lock),
        labelText: 'Password',
        errorText: model.passwordErrorText,
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 4.0),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0;

    return StreamBuilder<LoginModel>(
        stream: widget.bloc.modelStream,
        initialData: LoginModel(),
        builder: (context, snapshot) {
          final LoginModel model = snapshot.data;
          model.canSubmit;

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
              child: ModalProgressHUD(
                inAsyncCall: model.showSpinner,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Hero(
                          tag: 'logo',
                          child: Container(
                            height: 150.0,
                            child: Image.asset('assets/images/MLogoWhite.png'),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Container(
                            child: _buildEmailTextField(model),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Container(
                            child: _buildPasswordTextField(model),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: RoundedButton(
                            onPressed: model.canSubmit ? _submit : null,
                            title: 'Log In',
                            buttonColor: model.canSubmit
                                ? kMentorXPrimary
                                : Colors.grey.withOpacity(0.9),
                            minWidth: 500,
                            fontColor: model.canSubmit
                                ? Colors.white
                                : Colors.grey.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              onTap: () => widget._forgotPassword(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
