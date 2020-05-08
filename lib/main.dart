import 'package:flutter/material.dart';
import 'package:gh_styles/services/route_service.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:gh_styles/shared_preferences/shared_prefs.dart';

void main() {
  runApp(MyApp());
  // SharedPrefs prefs = new SharedPrefs();
  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        platform: TargetPlatform.android,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
