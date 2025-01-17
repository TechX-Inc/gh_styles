import 'package:flutter/material.dart';
import 'package:gh_styles/widgets/login_form.dart';
import 'package:provider/provider.dart';
import 'package:gh_styles/providers/login_provider.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // final AuthService _auth = new AuthService();
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
}
