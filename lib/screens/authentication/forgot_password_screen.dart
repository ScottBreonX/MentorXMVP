import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/screens/authentication/reset_password_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key key, @required this.bloc}) : super(key: key);
  final LoginBloc bloc;
  static const String id = 'forgot_password_screen';

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<LoginBloc>(
      create: (_) => LoginBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<LoginBloc>(
        builder: (_, bloc, __) => ForgotPasswordScreen(bloc: bloc),
      ),
    );
  }

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  String _email;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      onChanged: (value) {
        _email = value.trim();
      },
      style: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w500,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        prefixIcon: Icon(
          Icons.email,
          color: kMentorXPAccentMed,
        ),
        labelText: 'Email',
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        hintText: 'email@domain.com',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kMentorXPAccentMed, width: 4.0),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
      ),
    );
  }

  bool isLoading = false;

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
      body: Stack(
        children: [
          isLoading
              ? Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 1.0,
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                )
              : Text(""),
          Opacity(
            opacity: isLoading ? 0.2 : 1.0,
            child: Container(
              padding: EdgeInsets.only(top: 100),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                    Colors.grey.shade600,
                    kMentorXPPrimary,
                  ])),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 50.0, bottom: 50),
                      //   child: Hero(
                      //     tag: 'logo',
                      //     child: Container(
                      //       child: Image.asset(
                      //         'assets/images/MentorXP.png',
                      //         height: 70,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 20.0),
                        child: Column(
                          children: [
                            Text(
                              'Forgot Password?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kMentorXPAccentMed,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Reset password by entering email address below',
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
                        child: Container(
                          child: _buildEmailTextField(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: RoundedButton(
                          textAlignment: MainAxisAlignment.center,
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await auth
                                .sendPasswordResetEmail(email: _email)
                                .then(
                                  (value) => Navigator.popAndPushNamed(
                                      context, ResetPasswordScreen.id),
                                );
                            Future.delayed(Duration(seconds: 3));
                            setState(() {
                              isLoading = false;
                            });
                          },
                          title: 'Reset Password',
                          buttonColor: kMentorXPSecondary,
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
          ),
        ],
      ),
    );
  }
}
