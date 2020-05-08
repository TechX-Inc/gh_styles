import 'package:flutter/material.dart';
import 'package:gh_styles/authentication/auth_service.dart';
import 'package:gh_styles/models/users.dart';
import 'package:gh_styles/screens/landing_page.dart';
import 'package:gh_styles/screens/product_listing.dart';
import 'package:gh_styles/screens/slider_layout_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:gh_styles/screens/landing_page.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool firstRun = true;

  Future<void> _setFirstInstance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isFirst", false);
  }

  Future<void> _getFirstInstance() async {
    final prefs = await SharedPreferences.getInstance();
    final startup = prefs.getBool('isFirst');
    if (startup == null) {
      setState(() {
        firstRun = true;
      });
    }
    setState(() {
      firstRun = startup;
    });
  }

  @override
  void initState() {
    super.initState();
    _getFirstInstance();
     _setFirstInstance();
  }

  @override
  Widget build(BuildContext context) {
    // return Auth();
    return SafeArea(
        child: StreamProvider<User>.value(
            value: AuthService().user,
            child: firstRun == true ? SliderLayoutView() : Products()
            // child: Center(child: Text("Wrapper page"),),
        )
            
            );
  }
}
