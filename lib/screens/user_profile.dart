import 'package:flutter/material.dart';
import 'package:gh_styles/authentication/auth_service.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: RaisedButton(
        onPressed: (){new AuthService().signOut();},
        child: Text("SignOut"),
        )),
    );
  }
}