import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gh_styles/authentication/validation_login.dart';
import 'package:gh_styles/models/users.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:gh_styles/providers/login_provider.dart';

class LoginForm extends StatefulWidget {
  final dynamic widget;
  LoginForm({this.widget});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  LoginProvider _loginHandler;

  @override
  Widget build(BuildContext context) {
    _loginHandler = Provider.of<LoginProvider>(context, listen: false);
    return Form(
      key: _loginHandler.formKey,
      autovalidate: _loginHandler.autovalidate,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 60),
              child: Image.asset("assets/images/gh_style.png",
                  height: 90, width: 90),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Sign In",
                        style: GoogleFonts.cinzel(
                            textStyle: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 30)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _emailField(),
                  _passwordField(),
                  SizedBox(
                    height: 35,
                  ),
                  _signInBtn(),
                  _googleAuthBtn()
                ],
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                      text: 'Don\'t have an account?',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Sign up',
                            style: TextStyle(color: Colors.red, fontSize: 15),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                widget.widget.toggleView();
                              })
                      ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(hintText: "Email"),
      validator: (value) => ValidateLogin.validateEmail(value.trim()),
      onSaved: (email) => _loginHandler.setEmail = email,
    );
  }

  Widget _passwordField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Password",
      ),
      validator: (value) => ValidateLogin.validatePassword(value.trim()),
      onSaved: (password) => _loginHandler.setPassword = password,
    );
  }

  Widget _signInBtn() {
    return RaisedButton(
      color: Colors.black,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(child: Consumer<LoginProvider>(
          builder: (context, data, _) {
            return !data.loading
                ? Text(
                    "Sign In",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )
                : SpinKitThreeBounce(
                    color: Colors.white,
                    size: 25.0,
                  );
          },
        )),
      ),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      onPressed: () => _loginHandler.processAndSave(context),
    );
  }

  Widget _googleAuthBtn() {
    return RaisedButton(
      color: Color.fromRGBO(229, 229, 229, 1),
      child: FractionallySizedBox(
          widthFactor: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(FontAwesomeIcons.google, size: 18),
              SizedBox(
                width: 10,
              ),
              Text('Sign In with google'),
            ],
          )),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      onPressed: () => _loginHandler.googleAuth(),
    );
  }
}
