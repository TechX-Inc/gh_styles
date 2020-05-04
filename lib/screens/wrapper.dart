import 'package:flutter/material.dart';
import 'package:gh_styles/screens/auth_screens/auth.dart';
import 'package:gh_styles/screens/landing_page.dart';
// import 'package:gh_styles/screens/landing_page.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Auth();
    return SafeArea(child: LandingPage());
  }
}