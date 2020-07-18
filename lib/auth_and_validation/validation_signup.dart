import 'package:email_validator/email_validator.dart';

class ValidateSignUp {
  static String validateUsername(String username) {
    if (username.isEmpty) {
      return "This field cannot be empty";
    }
    return null;
  }

  static String validateEmail(String email) {
    if (email.isEmpty) {
      return "This field cannot be empty";
    } else if (!EmailValidator.validate(email)) {
      return "Enter a valid email";
    }
    return null;
  }

  static String validatePassword(String password) {
    if (password.isEmpty) {
      return "Please enter password";
    } else if (password.length < 6) {
      return "Password too short";
    }
    return null;
  }
}
