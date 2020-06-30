import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/authentication/auth_service.dart';
import 'package:gh_styles/models/users.dart';

class LoginProvider with ChangeNotifier {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = new AuthService();
  bool _autovalidate = false;
  bool _loading = false;
  String _email;
  String _password;

//GETTERS
  GlobalKey<FormState> get formKey => _formKey;
  AuthService get auth => _auth;
  bool get loading => _loading;
  bool get autovalidate => _autovalidate;

//SETTERS
  set setEmail(String email) {
    _email = email;
  }

  set setPassword(String password) {
    _password = password;
  }

  Widget snackBar(error) => SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      );

  Future<void> processAndSave(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      _autovalidate = true;
      _formKey.currentState.build(context);
      notifyListeners();
      return;
    } else {
      _formKey.currentState.save();
      _loading = true;
      notifyListeners();

      dynamic result = await _auth.login(_email, _password);

      if (result != FirebaseUser) {
        print(
            "<<<<<<<<<<<<==================== INVALID LOGIN VALUES ==================>>>>>>>>>>>");
        switch (result) {
          case "ERROR_USER_NOT_FOUND":
            Scaffold.of(context)
                .showSnackBar(snackBar("Email or password is incorrect"));
            _loading = false;
            notifyListeners();
            break;

          case "ERROR_WRONG_PASSWORD":
            Scaffold.of(context)
                .showSnackBar(snackBar("Email or password is incorrect"));
            _loading = false;
            notifyListeners();
            break;
          default:
            print(
                "UNEXPECTED ERROR <<<<<<<<<<<<==================== $result ==================>>>>>>>>>>>");
            Scaffold.of(context).showSnackBar(snackBar(
                "Oops...something went wrong, please try again or contact support"));
            _loading = false;
            notifyListeners();
        }
      } else {
        print(
            "<<<<<<<<<<<<==================== VALID LOGIN VALUES ==================>>>>>>>>>>>");
        print(result.runtimeType);
        _loading = false;
        notifyListeners();
        return;
      }
    }
  }

  void googleAuth() async {
    if (await _auth.registerWithGoogle() == User) {
      return;
    } else {
      print(
          "<<<<<<<<<============ GOOGLE AUTH ERROR OCCURED ============>>>>>>>>>>>");
    }
  }
}
