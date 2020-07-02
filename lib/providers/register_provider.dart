import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/authentication/auth_service.dart';
import 'package:gh_styles/models/users.dart';

class RegisterProvider with ChangeNotifier {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = new AuthService();
  bool _autovalidate = false;
  bool _maskPassword = true;
  bool _loading = false;
  String _username;
  String _email;
  String _password;

//GETTERS
  GlobalKey<FormState> get formKey => _formKey;
  AuthService get auth => _auth;
  bool get loading => _loading;
  bool get autovalidate => _autovalidate;
  bool get maskPassword => _maskPassword;

//SETTERS
  set setUsename(String username) {
    _username = username;
  }

  set setEmail(String email) {
    _email = email;
  }

  set setPassword(String password) {
    _password = password;
  }

  set setPasswordMask(bool passwordMask) {
    _maskPassword = passwordMask;
    notifyListeners();
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

      dynamic result =
          await _auth.register(_username.trim(), _email.trim(), _password);

      if (result != FirebaseUser) {
        print(
            "<<<<<<<<<<<<==================== INVALID REGISTER VALUES ==================>>>>>>>>>>>");
        switch (result) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
            Scaffold.of(context)
                .showSnackBar(snackBar("This user already exist"));
            _loading = false;
            notifyListeners();
            break;

          default:
            print(
                "UNEXPECTED ERROR <<<<<<<<<<<<==================== $result ==================>>>>>>>>>>>");
            Scaffold.of(context).showSnackBar(
                snackBar("Oops...something went wrong, please try again"));
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
