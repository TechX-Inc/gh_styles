import 'package:email_validator/email_validator.dart';

class ValidateForm {
  static String validateLoginEmail(String email) {
    if (email.isEmpty) {
      return "Enter your email";
    } else if (!EmailValidator.validate(email)) {
      return "Enter a valid email";
    }

  }

  static String validateLoginPassword(String password) {
    if (password.isEmpty) {
      return "Enter password";
    }
   
  }
}
