import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gh_styles/authentication/auth_service.dart';

class LoginValidation extends FormBloc<String, String> {
  final AuthService _auth = new AuthService();
  final email =
      TextFieldBloc(validators: [FieldBlocValidators.required, _validateEmail]);
  final password = TextFieldBloc(validators: [FieldBlocValidators.required]);

  LoginValidation() {
    addFieldBlocs(
      fieldBlocs: [email, password],
    );
  }

  static String _validateEmail(String email) {
    email = email.split(" ").join("");
    if (!EmailValidator.validate(email)) {
      return "Enter a valid email";
    }
    return null;
  }

  @override
  void onSubmitting() async {
    print(email.value);
    print(password.value);

    final user =
        await _auth.login(email.value.split(" ").join(""), password.value);
    print(user.runtimeType);

    if (user.runtimeType == FirebaseUser) {
      emitSuccess();
    } else {
      switch (user) {
        case "ERROR_USER_NOT_FOUND":
          email.addError(
            'User does not exist',
            isPermanent: true,
          );
          emitFailure(failureResponse: 'The user specified does not exist');
          break;
        case "ERROR_WRONG_PASSWORD":
          password.addError(
            'Incorrect password',
            isPermanent: true,
          );
          emitFailure(failureResponse: 'Please enter a valid password');
          break;
        default:
          print("AN ERROR OCCURED: $user");
          emitFailure(failureResponse: '$user');
      }
    }
  }
}
