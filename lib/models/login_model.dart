import 'package:mentorx_mvp/components/validators.dart';

class LoginModel with EmailAndPasswordValidators {
  LoginModel({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.submitted = false,
    this.showSpinner = false,
  });

  final String email;
  final String password;
  final String confirmPassword;
  final bool submitted;
  final bool showSpinner;

  bool get canSubmit {
    return emailValidator.isValid(email) && passwordValidator.isValid(password);
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidEmailErrorText : null;
  }

  LoginModel copyWith({
    String email,
    String password,
    String confirmPassword,
    bool submitted,
    bool showSpinner,
  }) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      submitted: submitted ?? this.submitted,
      showSpinner: showSpinner ?? this.showSpinner,
    );
  }
}
