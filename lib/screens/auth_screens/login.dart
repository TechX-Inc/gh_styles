import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gh_styles/authentication/validation.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final textController = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
          body: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 60),
                child: Image.asset("assets/images/gh_style.png",
                    height: 90, width: 90),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: new Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Login",
                            style: GoogleFonts.cinzel(
                                textStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 30)),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        decoration: InputDecoration(
                          focusColor: Colors.red,
                          hintText: "Email",
                        ),
                        validator: (val) => Validator.validateEmail(val),
                        onSaved: (val) => _email = val,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Password",
                      focusColor: Colors.red,
                          suffix: Container(
                            margin: EdgeInsets.only(
                              right: 10,
                            ),
                            child: GestureDetector(
                              onTap: () => {print('hello')},
                              child:  Text(
                            "Forgot?",
                            style: GoogleFonts.firaSans(
                                textStyle: TextStyle(
                                    fontSize: 15)),
                          ),
      
                            ),
                          ),
                        ),
                        validator: (val) => Validator.validatePassword(val),
                        onSaved: (val) => _password = val,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      RaisedButton(
                        color: Colors.black,
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                              child: Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: _submit,
                      ),
                      RaisedButton(
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
                                Text('Login with google'),
                              ],
                            )),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: _submit,
                      ),
                    ],
                  ),
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
                                  print('tapped');
                                })
                        ]),
                  ),
                ],
              )
            ],
          )),
    );
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      //Login
    }
  }
}
