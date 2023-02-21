import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/models/login_model.dart';
import 'package:mentorx_mvp/screens/authentication/login_screen.dart';
import 'package:mentorx_mvp/screens/authentication/registration_profile_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/database.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({@required this.bloc});

  static const String id = 'registration_screen';
  final LoginBloc bloc;
  final _auth = FirebaseAuth.instance;

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
    Navigator.of(context).pushReplacement(
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  String uid;
  String email;

  Future<void> _submit() async {
    try {
      await widget.bloc.createUser().then((_) {
        uid = widget._auth.currentUser.uid;
        email = widget._auth.currentUser.email;
      });
      Navigator.of(context).popAndPushNamed(RegistrationProfileScreen.id);
    } on FirebaseAuthException catch (e) {
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
      } else {
        showAlertDialog(
          context,
          title: "Password",
          content: "Password should be at least 6 characters in length",
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

  Future<void> _createProfile(BuildContext context) async {
    try {
      final database = FirestoreDatabase();
      await database.createProfile(
        myUser(
          id: uid,
          email: email,
          firstName: '',
          lastName: '',
          aboutMe: '',
          mentorAbout: '',
          menteeAbout: '',
          profilePicture: '',
          coverPhoto: '',
          canCreateProgram: false,
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation Failed', content: '$e', defaultActionText: 'Ok');
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

  TextField _buildPasswordTextField(LoginModel model) {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.done,
      onChanged: widget.bloc.updatePassword,
      style: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w500,
      ),
      decoration: kTextFieldDecorationLight.copyWith(
        prefixIcon: Icon(
          Icons.lock,
          color: kMentorXPAccentMed,
        ),
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
          borderSide: BorderSide(color: kMentorXPAccentMed, width: 4.0),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
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
        color: Colors.black54,
        fontWeight: FontWeight.w500,
      ),
      decoration: kTextFieldDecorationLight.copyWith(
        prefixIcon: Icon(
          Icons.lock,
          color: kMentorXPAccentMed,
        ),
        labelText: 'Re-Enter Password',
        errorText: model.passwordErrorText,
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        hintText: 'Re-Enter Password',
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoginModel>(
        stream: widget.bloc.modelStream,
        initialData: LoginModel(),
        builder: (context, snapshot) {
          final LoginModel model = snapshot.data;
          // model.canSubmit;

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
            ),
            body: Container(
              padding: EdgeInsets.only(top: 100),
              height: double.infinity,
              width: double.infinity,
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
                            child: Image.asset('assets/images/MentorXP.png'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: _buildEmailTextField(model),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: _buildPasswordTextField(model),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: _buildConfirmPasswordTextField(model),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: RoundedButton(
                            textAlignment: MainAxisAlignment.center,
                            onPressed: !model.canSubmit
                                ? () {}
                                : () {
                                    if (model.password !=
                                        model.confirmPassword) {
                                      showAlertDialog(
                                        context,
                                        title: "Confirm Password",
                                        content:
                                            "Passwords do not match. Please re-enter password.",
                                        defaultActionText: "Ok",
                                      );
                                    } else {
                                      _submit().then((_) async {
                                        await _createProfile(context);
                                      });
                                    }
                                  },
                            title: 'Next',
                            buttonColor: model.canSubmit
                                ? kMentorXPAccentMed
                                : Colors.grey,
                            fontColor: model.canSubmit
                                ? Colors.white
                                : Colors.grey.shade400,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            minWidth: 500.0,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?  ',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            InkWell(
                              child: Text(
                                'Log In',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: kMentorXPAccentMed,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat',
                                ),
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
