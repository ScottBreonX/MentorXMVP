import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mentorx_mvp/components/alert_dialog.dart';
import 'package:mentorx_mvp/bottom_navigation_bar.dart';
import 'package:mentorx_mvp/models/login_bloc.dart';
import 'package:mentorx_mvp/models/login_model.dart';
import 'package:mentorx_mvp/screens/registration/registration_screen.dart';
import 'package:mentorx_mvp/services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:provider/provider.dart';

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
  _LoginScreenBlocBasedState createState() => _LoginScreenBlocBasedState();
}

class _LoginScreenBlocBasedState extends State<LoginScreenBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).popAndPushNamed(XBottomNavigationBar.id);
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
        color: kMentorXTeal,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: false,
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: 'Enter your email',
        hintText: 'email@domain.com',
        errorText: model.emailErrorText,
        fillColor: Colors.white70,
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
        color: kMentorXTeal,
        fontWeight: FontWeight.w400,
      ),
      decoration: kTextFieldDecorationLight.copyWith(
        labelText: 'Enter your password',
        errorText: model.passwordErrorText,
        filled: true,
        fillColor: Colors.white70,
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
              backgroundColor: kMentorXTeal,
              title: Text('Log In'),
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/XBackground.png'),
                  fit: BoxFit.cover,
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
                            child: Image.asset('images/XLogo.png'),
                          ),
                        ),
                        SizedBox(
                          height: 48.0,
                        ),
                        _buildEmailTextField(model),
                        SizedBox(
                          height: 20,
                        ),
                        _buildPasswordTextField(model),
                        SizedBox(height: 20.0),
                        RoundedButton(
                          onPressed: model.canSubmit ? _submit : null,
                          title: 'LOG IN',
                          buttonColor: model.canSubmit
                              ? kMentorXTeal
                              : Colors.grey.shade600,
                          minWidth: 500,
                          fontColor: Colors.white,
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        Center(
                          child: InkWell(
                            child: Text(
                              'Need an account? Register',
                              style:
                                  TextStyle(fontSize: 20, color: kMentorXTeal),
                            ),
                            onTap: () => widget._createNewUser(context),
                          ),
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
