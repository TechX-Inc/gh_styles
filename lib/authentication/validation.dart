class Validator {
  static String validateEmail(String value) {
    if (value.length <= 0) {
      return 'Email cannot be empty';
    } else if (!value.contains('@')) {
      return 'Enter a valid email';
    } else {
      return null;
    }
  }

  static String validatePassword(String pass) {
    if (pass.length <= 0) {
      return 'Password cannot be empty';
    } else if (pass.length < 6) {
      return 'Password too short';
    } else {
      return null;
    }
  }
}
