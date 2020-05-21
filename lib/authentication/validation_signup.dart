import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gh_styles/authentication/auth_service.dart';
import 'package:gh_styles/models/users.dart';

class AsyncFieldValidationFormBloc extends FormBloc<String, String> {
  final _auth = new AuthService();

  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      _min2Char,
    ],
  );

  final email = TextFieldBloc(
    validators: [FieldBlocValidators.required, _validateEmail],
    asyncValidatorDebounceTime: Duration(milliseconds: 500),
  );

  final password = TextFieldBloc(
    validators: [FieldBlocValidators.required, _validatePassword],
  );

  AsyncFieldValidationFormBloc() {
    addFieldBlocs(fieldBlocs: [username, email, password]);
    email.addAsyncValidators(
      [_checkEmail],
    );
  }

  static String _min2Char(String username) {
    username = username.split(" ").join("");
    if (username.length < 2) {
      return 'The username must have at least 2 characters';
    }
    return null;
  }

  static String _validateEmail(String email) {
    email = email.split(" ").join("");
    if (!EmailValidator.validate(email)) {
      return "Enter a valid email";
    }
    return null;
  }

  Future<String> _checkEmail(String email) async {
    email = email.split(" ").join("");
    final mail_exist = await _auth.register(email, "EMAIL_CHECK");
    if (mail_exist.runtimeType == User) {
      print("USER ID ${mail_exist.uid}");
      FirebaseAuth.instance.currentUser().then(
          (user) => {print("FIREBASE USER ID ${user.uid}"), user.delete()});
    } else {
      switch (mail_exist.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          return "Email already exist";
          break;
        default:
          return null;
      }
    }
    return null;
  }

  static String _validatePassword(String pass) {
    if (pass.length < 6) {
      return 'Your password is weak';
    } else {
      return null;
    }
  }

  @override
  void onSubmitting() async {
    User newUser = await _auth.register(
        email.value.split(" ").join(""), password.value, username.value);
    try {
      if (newUser.runtimeType == User) {
        new User().saveUser(newUser.uid, username.value, newUser.email);
      }
      emitSuccess();
    } catch (e) {
      emitFailure();
    }
  }
}
