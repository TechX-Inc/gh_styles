import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gh_styles/authentication/auth_service.dart';
import 'package:gh_styles/authentication/validation_signup.dart';
import 'package:gh_styles/providers/register_provider.dart';
import 'package:gh_styles/utils/register_form.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ChangeNotifierProvider(
              create: (context) => RegisterProvider(),
              child: RegisterForm(widget: widget))),
    );
  }
}
