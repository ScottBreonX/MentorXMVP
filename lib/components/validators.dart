abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = 'Email can\'t be empty';
  final String invalidPasswordErrorText = 'Email can\'t be empty';
}

class ChatMessageValidator {
  final StringValidator messageValidator = NonEmptyStringValidator();
}

class CreateProgramValidator {
  final StringValidator instituionNameValidator = NonEmptyStringValidator();
  final StringValidator enrollmentTypeValidator = NonEmptyStringValidator();
  final StringValidator aboutProgramValidator = NonEmptyStringValidator();
  final StringValidator headAdminValidator = NonEmptyStringValidator();
  final StringValidator programNameValidator = NonEmptyStringValidator();
  final String instituionNameErrorText = 'College name can\'t be empty';
  final String enrollmentTypeErrorText = 'Enrollment type can\'t be empty';
  final String aboutProgramErrorText = 'Description of program can\'t be empty';
  final String headAdminErrorText = 'Head Admin of program can\'t be empty';
  final String programNameErrorText = 'Program name can\'t be empty';
}
