import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gh_styles/authentication/auth_service.dart';
import 'package:gh_styles/authentication/validation_signup.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AsyncFieldValidationFormBloc(),
      child: Builder(
        builder: (context) {
          final AsyncFieldValidationFormBloc formBloc =
              context.bloc<AsyncFieldValidationFormBloc>();

          return SafeArea(
            child: Scaffold(
              body: FormBlocListener<AsyncFieldValidationFormBloc, String,
                  String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);
                  Navigator.pushReplacementNamed(context, '/products_wrapper');
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
                        margin: EdgeInsets.only(top: 40),
                        child: Image.asset("assets/images/gh_style.png",
                            height: 90, width: 90),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
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
                              SizedBox(height: 20),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.username,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.email,
                                suffixButton: SuffixButton.asyncValidating,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.password,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                ),
                                suffixButton: SuffixButton.obscureText,
                              ),
                              // TextFieldBlocBuilder(
                              //   textFieldBloc: formBloc.confirmPassword,
                              //   decoration: InputDecoration(
                              //     hintText: "Confirm Password",
                              //   ),
                              //   suffixButton: SuffixButton.obscureText,
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
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                onPressed: formBloc.submit,
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
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                onPressed: () =>
                                    new AuthService().registerWithGoogle(),
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                      Column(
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                                text: 'Already have an account?',
                                style:
                                    TextStyle(color: Colors.black, fontSize: 15),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' Login',
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
          );
        },
      ),
    );
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

