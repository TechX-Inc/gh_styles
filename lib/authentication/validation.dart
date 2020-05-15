import 'package:email_validator/email_validator.dart';
import 'package:gh_styles/authentication/auth_service.dart';

class Validator {
  final AuthService _auth = new AuthService();

  String validateEmail(String email){
    String trimEmail = email.replaceAll(' ', '');
    if (trimEmail.length <= 0) {
      return 'Enter an email';
    } else if (!EmailValidator.validate(trimEmail)) {
      return 'Enter a valid email';
    }
     else {
      return null;
    }
  }

  static String validateUsername(String value) {
    if (value.length <= 0) {
      return 'Enter a username';
    } else {
      return null;
    }
  }

  static String validatePassword(String pass) {
    if (pass.length <= 0) {
      return 'Enter a password';
    } else if (pass.length < 6) {
      return 'Enter a stronger password';
    } else {
      return null;
    }
  }

  static String validateEmailLogin(String value) {
    //CHECK IF EMAIL EXIST
    if (value.length <= 0) {
      return 'Email cannot be empty';
    } else if (!value.contains('@')) {
      return 'Enter a valid email';
    } else {
      return null;
    }
  }

  static String validatePasswordLogin(String pass) {
    //CHECK IF PASSWORDS MATCH CORRECT
    if (pass.length <= 0) {
      return 'Password cannot be empty';
    } else {
      return null;
    }
  }
}
