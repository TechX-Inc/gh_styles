import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gh_styles/authentication/validation.dart';

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
                margin: EdgeInsets.only(top: 80),
                child: Image.asset("assets/images/gh_style.jpg",
                    height: 90, width: 90),
              ),
              SizedBox(height: 60),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: new Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                        ),
                        validator: (val) => Validator.validateEmail(val),
                        onSaved: (val) => _email = val,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Password",
                        ),
                        validator: (val) =>Validator.validatePassword(val),
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
                          child: Container(child: Text("Login", textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
                        ),
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: _submit,
                      ),
                        RaisedButton(
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.google, size: 18),
                              SizedBox(width: 10,),
                              Text('Login with google'),
                            ],
                          )
                        ),
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: _submit,
                      )
                    ],
                  ),
                ),
              ),
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
