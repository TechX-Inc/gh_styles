import 'package:flutter/material.dart';
import 'package:gh_styles/screens/auth_screens/login.dart';


class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //if authenticated ? profile : login 
    return Login();
  }
}