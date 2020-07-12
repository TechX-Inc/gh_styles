import 'package:email_validator/email_validator.dart';

class ValidateLogin {
  static String validateEmail(String email) {
    if (email.isEmpty) {
      return "Please enter email";
    } else if (!EmailValidator.validate(email)) {
      return "Enter a valid email";
    }
    return null;
  }

  static String validatePassword(String password) {
    if (password.isEmpty) {
      return "Please enter password";
    }
    return null;
  }
}
