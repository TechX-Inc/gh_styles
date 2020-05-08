// import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{
  bool _firstRun = true;
  bool get firstRun => _firstRun;

  // Future<void> _setFirstInstance() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool("isFirst", false);
  // }

  Future<void> _checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    final firstStartup = prefs.getBool('isFirst');
    if (firstStartup != null && !firstStartup) {
      //not first time
      _firstRun = false;
    } else {
      //first time
      prefs.setBool('isFirst', false);
      _firstRun = true;
    }
   
  }

  SharedPrefs() {
    _checkFirstRun();
    // _setFirstInstance();
  }
}
