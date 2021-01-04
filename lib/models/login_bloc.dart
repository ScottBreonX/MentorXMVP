import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mentorx_mvp/models/login_model.dart';
import 'package:mentorx_mvp/services/auth.dart';

class LoginBloc {
  LoginBloc({@required this.auth});
  final AuthBase auth;

  final StreamController<LoginModel> _modelController =
      StreamController<LoginModel>();
  Stream<LoginModel> get modelStream => _modelController.stream;
  LoginModel _model = LoginModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> submit() async {
    updateWith(submitted: true, showSpinner: true);
    try {
      await auth.signInWithEmailAndPassword(_model.email, _model.password);
    } catch (e) {
      updateWith(showSpinner: false);
      rethrow;
    }
  }

  Future<void> createUser() async {
    updateWith(submitted: true, showSpinner: true);
    try {
      await auth.createUserWithEmailAndPassword(_model.email, _model.password);
    } catch (e) {
      updateWith(showSpinner: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void updateConfirmPassword(String confirmPassword) =>
      updateWith(confirmPassword: confirmPassword);

  void updateWith({
    String email,
    String password,
    String confirmPassword,
    bool submitted,
    bool showSpinner,
  }) {
    //update model
    _model = _model.copyWith(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      submitted: submitted,
      showSpinner: showSpinner,
    );
    //add updated model to _modelController
    _modelController.add(_model);
  }
}
