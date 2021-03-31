import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/models/login_model.dart';
import 'package:mentorx_mvp/screens/login/login_screen.dart';
import 'package:mentorx_mvp/screens/registration/registration_profile_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({@required this.bloc});

  static const String id = 'registration_screen';
  final LoginBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<LoginBloc>(
      create: (_) => LoginBloc(auth: auth),
      child: Consumer<LoginBloc>(
        builder: (_, bloc, __) => RegistrationScreen(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
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

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  Future<void> _submit() async {
    try {
      await widget.bloc.createUser();
      Navigator.of(context).popAndPushNamed(RegistrationProfileScreen.id);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if (e.code == 'invalid-email') {
        showAlertDialog(
          context,
          title: "Invalid Email",
          content: "Please enter a valid email address",
          defaultActionText: "Ok",
        );
      }
      if (e.code == 'email-already-in-use') {
        showAlertDialog(
          context,
          title: "Email already in use",
          content:
              "Email is already in use. Try new email or proceed to log in.",
          defaultActionText: "Ok",
        );
      }
    } catch (e) {
      showAlertDialog(
        context,
        title: "Invalid Registration",
        content: "Please enter a valid email and password",
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
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: 'Enter your email',
        labelStyle: TextStyle(color: Colors.white),
        hintText: 'email@domain.com',
        errorText: model.emailErrorText,
        fillColor: kMentorXDark,
        filled: true,
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
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: 'Enter your password',
        labelStyle: TextStyle(color: Colors.white),
        errorText: model.passwordErrorText,
        fillColor: kMentorXDark,
        filled: true,
      ),
    );
  }

  TextField _buildConfirmPasswordTextField(LoginModel model) {
    return TextField(
      controller: _passwordConfirmController,
      obscureText: true,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.done,
      onChanged: widget.bloc.updateConfirmPassword,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: 'Re-enter your password',
        labelStyle: TextStyle(color: Colors.white),
        errorText: model.passwordErrorText,
        fillColor: kMentorXDark,
        filled: true,
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
            appBar: AppBar(
              backgroundColor: kMentorXPrimary,
              title: Text('Create Account'),
              centerTitle: true,
            ),
//            backgroundColor: Colors.white,
            body: Container(
              height: double.infinity,
              width: double.infinity,
              color: kMentorXDark,
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
                        SizedBox(
                          height: 0,
                        ),
                        Hero(
                          tag: 'logo',
                          child: Container(
                            height: 150.0,
                            child: Image.asset('images/XLogo.png'),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _buildEmailTextField(model),
                        SizedBox(
                          height: 20,
                        ),
                        _buildPasswordTextField(model),
                        SizedBox(
                          height: 20.0,
                        ),
                        _buildConfirmPasswordTextField(model),
                        SizedBox(height: 10.0),
                        RoundedButton(
                          onPressed: () {
                            if (model.password != model.confirmPassword) {
                              showAlertDialog(
                                context,
                                title: "Confirm Password",
                                content:
                                    "Passwords do not match. Please re-enter password.",
                                defaultActionText: "Ok",
                              );
                            } else {
                              _submit();
                            }
                          },
                          title: 'NEXT',
                          buttonColor: kMentorXPrimary,
                          fontColor: Colors.white,
                          minWidth: 500.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?  ',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            InkWell(
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: kMentorXPrimary,
                                    fontWeight: FontWeight.w600),
                              ),
                              onTap: () => widget._signInWithEmail(context),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 100,
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
