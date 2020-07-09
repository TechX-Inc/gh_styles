import 'package:flutter/material.dart';
import 'package:gh_styles/screens/product_wrapper.dart';
import 'package:gh_styles/screens/slider_layout_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool firstStartup = true;

  Future<void> _checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    firstStartup = prefs.getBool('isFirst');
    if (firstStartup != null && !firstStartup) {
      setState(() {
        firstStartup = prefs.getBool('isFirst');
      });
    } else {
      prefs.setBool('isFirst', false);
      setState(() {
        firstStartup = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: firstStartup == true ? SliderLayoutView() : ProductWrap());
  }
}
