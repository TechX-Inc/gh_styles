import 'package:flutter/material.dart';
import 'package:gh_styles/screens/wrapper.dart';
import 'package:gh_styles/services/route_service.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute : '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}