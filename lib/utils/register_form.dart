import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gh_styles/authentication/validation_signup.dart';
import 'package:gh_styles/providers/login_provider.dart';
import 'package:gh_styles/providers/register_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  final dynamic widget;
  RegisterForm({this.widget});
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  RegisterProvider _registerHandler;

  @override
  Widget build(BuildContext context) {
    _registerHandler = Provider.of<RegisterProvider>(context, listen: false);
    return Form(
      key: _registerHandler.formKey,
      autovalidate: _registerHandler.autovalidate,
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
                  _username(),
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

  Widget _username() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(hintText: "Username"),
      validator: (value) => ValidateSignUp.validateUsername(value.trim()),
      onSaved: (username) => _registerHandler.setUsename = username,
    );
  }

  Widget _emailField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(hintText: "Email"),
      validator: (value) => ValidateSignUp.validateEmail(value.trim()),
      onSaved: (email) => _registerHandler.setEmail = email,
    );
  }

  Widget _passwordField() {
    return Consumer<RegisterProvider>(builder: (context, data, _) {
      return TextFormField(
        keyboardType: TextInputType.multiline,
        obscureText: data.maskPassword,
        decoration: InputDecoration(
            hintText: "Password",
            suffixIcon: IconButton(
                icon: Icon(
                  data.maskPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black38,
                  size: 23.0,
                ),
                onPressed: () {
                  data.setPasswordMask = !data.maskPassword;
                })),
        validator: (value) => ValidateSignUp.validatePassword(value.trim()),
        onSaved: (password) => _registerHandler.setPassword = password,
      );
    });
  }

  Widget _signInBtn() {
    return RaisedButton(
      color: Colors.black,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(child: Consumer<RegisterProvider>(
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
      onPressed: () => _registerHandler.processAndSave(context),
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
      onPressed: () => _registerHandler.googleAuth(),
    );
  }
}
