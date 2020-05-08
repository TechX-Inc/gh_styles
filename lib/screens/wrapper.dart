import 'package:flutter/material.dart';
import 'package:gh_styles/authentication/auth_service.dart';
import 'package:gh_styles/models/users.dart';
import 'package:gh_styles/screens/landing_page.dart';
import 'package:provider/provider.dart';
// import 'package:gh_styles/screens/landing_page.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Auth();
    return SafeArea(
      child: StreamProvider<User>.value(
        value: AuthService().user,
        child: LandingPage()
        )
      );
  }
}