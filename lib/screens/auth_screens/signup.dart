import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gh_styles/authentication/auth_service.dart';
import 'package:gh_styles/authentication/validation.dart';
import 'package:gh_styles/models/users.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final textController = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  final AuthService _auth = new AuthService();
  bool mailExist = false;

  String _email;
  String _password;
  String _username;
  // String emialExist = '';

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
                            "Register",
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
                          // focusColor: Colors.red,
                          hintText: "Username",
                        ),
                        validator: (val)=>Validator.validateUsername(val),                        
                        onSaved: (val) => _username = val,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Email",
                        ),
                        validator: (val) => new Validator().validateEmail(val),
                        onSaved: (val) => _email = val,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Password",
                        ),
                        validator: (val) => Validator.validatePassword(val),
                        onSaved: (val) => _password = val,
                        obscureText: true,
                      ),

                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: <Widget>[
                      //     RichText(
                      //       text: TextSpan(
                      //           text: 'By signing up you agree to our',
                      //           style: TextStyle(
                      //               color: Colors.black, fontSize: 15),
                      //           children: <TextSpan>[
                      //             TextSpan(
                      //                 text: ' Terms and Privacy Policy',
                      //                 style: TextStyle(
                      //                     color: Colors.red, fontSize: 15),
                      //                 recognizer: TapGestureRecognizer()
                      //                   ..onTap = () {
                      //                     Navigator.of(context)
                      //                         .pushReplacementNamed('/login');
                      //                   })
                      //           ]),
                      //     ),
                      //   ],
                      // ),

                      SizedBox(
                        height: 40,
                      ),
                      RaisedButton(
                        color: Colors.black,
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                              child: Text(
                            "Signup",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: _emailAuth,
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
                                Text('Signup with google'),
                              ],
                            )),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: _googleAuth,
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
                        text: 'Already have an account?',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' Login',
                              style: TextStyle(color: Colors.red, fontSize: 15),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/login');
                                })
                        ]),
                  ),
                ],
              )
            ],
          )),
    );
  }

  void _emailAuth() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      dynamic result = await _auth.register(
          _email.replaceAll(' ', ''), _password, _username.replaceAll(' ', ''));
      if (result != null && result.runtimeType != bool) {
        Navigator.pushReplacementNamed(context, '/products_wrapper');
      }else if(result.runtimeType == bool){
        //email exist; errors not set yet
      }
    }
  }

  void _googleAuth() async {
    if (_auth.registerWithGoogle() != null) {
      Navigator.pushReplacementNamed(context, '/products_wrapper');
    }
  }
}
