import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/models/users.dart';
import 'package:gh_styles/screens/auth_screens/auth.dart';
import 'package:gh_styles/screens/product_listing.dart';
import 'package:gh_styles/screens/slider_layout_view.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: onBordingBody(context),
    );
  }

   Widget onBordingBody(BuildContext context){
     final user = Provider.of<User>(context);
     return Container(
        child: user == null ? Auth() : Products(),
      );
   }

  // Widget onBordingBody(BuildContext context) => Container(
  //       child: Auth(),
  //     );
}
