import 'package:flutter/material.dart';
import 'package:gh_styles/providers/register_provider.dart';
import 'package:gh_styles/utils/register_form.dart';
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
