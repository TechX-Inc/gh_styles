
//NOT USED
import 'package:flutter/material.dart';
import 'package:gh_styles/screens/auth_screens/login.dart';
import 'package:gh_styles/screens/auth_screens/signup.dart';

import '../slider_layout_view.dart';


class ToggleLoginSignUp extends StatefulWidget {
  @override
  _ToggleLoginSignUpState createState() => _ToggleLoginSignUpState();
}

class _ToggleLoginSignUpState extends State<ToggleLoginSignUp> {

  bool _showSignIn = true;
  void toggleView (){
    setState(() => _showSignIn = !_showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (_showSignIn) {
      return Login(toggleView: toggleView);
    } else {
      return SignUp(toggleView: toggleView);
    }
  }
}