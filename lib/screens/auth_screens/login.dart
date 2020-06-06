import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gh_styles/authentication/auth_service.dart';
import 'package:gh_styles/authentication/validation_login.dart';
import 'package:gh_styles/models/users.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginValidation(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<LoginValidation>(context);

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(),
            ),
            child: SafeArea(
              child: Scaffold(
                body: FormBlocListener<LoginValidation, String, String>(
                  onSubmitting: (context, state) {
                    LoadingDialog.show(context);
                  },
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);
                    Navigator.pushReplacementNamed(
                        context, '/products_wrapper');
                  },
                  onFailure: (context, state) {
                    LoadingDialog.hide(context);

                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text(state.failureResponse)));
                  },
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
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.email,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(hintText: "Email"),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.password,
                                keyboardType: TextInputType.multiline,
                                // obscureText: true,
                                suffixButton: SuffixButton.obscureText,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                ),
                              ),
                              SizedBox(
                                height: 35,
                              ),
                              RaisedButton(
                                color: Colors.black,
                                child: FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Container(
                                      child: Text(
                                    "Sign In",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                onPressed: formBloc.submit,
                              ),
                              RaisedButton(
                                color: Color.fromRGBO(229, 229, 229, 1),
                                child: FractionallySizedBox(
                                    widthFactor: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.google, size: 18),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Sign In with google'),
                                      ],
                                    )),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                onPressed: _googleAuth,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                  text: 'Don\'t have an account?',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' Sign up',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 15),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            widget.toggleView();
                                          })
                                  ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _googleAuth() async {
    if (await _auth.registerWithGoogle() == User) {
      Navigator.pushReplacementNamed(context, '/products_wrapper');
    }
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  SuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.tag_faces, size: 100),
            SizedBox(height: 10),
            Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
              onPressed: () => Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) => Login())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
