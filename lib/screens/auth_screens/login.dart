import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gh_styles/authentication/auth_service.dart';
import 'package:gh_styles/authentication/validation_login.dart';
import 'package:gh_styles/models/users.dart';
import 'package:gh_styles/utils/login_form.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:gh_styles/providers/login_provider.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(),
      ),
      child: SafeArea(
        child: Scaffold(
            body: ChangeNotifierProvider(
                create: (context) => LoginProvider(),
                child: LoginForm(widget: widget))),
      ),
    );
  }

  void _googleAuth() async {
    if (await _auth.registerWithGoogle() == User) {
      Navigator.pushReplacementNamed(context, '/products_wrapper');
    }
  }
}
