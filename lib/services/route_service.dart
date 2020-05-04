import 'package:flutter/material.dart';
import 'package:gh_styles/screens/auth_screens/forgot.dart';
import 'package:gh_styles/screens/auth_screens/login.dart';
import 'package:gh_styles/screens/auth_screens/signup.dart';
import 'package:gh_styles/screens/item_profile.dart';
import 'package:gh_styles/screens/wrapper.dart';
import '../main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Wrapper());

      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUp());

      case '/login':
        return MaterialPageRoute(builder: (_) => Login());

      case '/forgot_password':
        return MaterialPageRoute(builder: (_) => ForgotPassword());

      case '/item_profile':
        return MaterialPageRoute(builder: (_) => ItemProfile());
        // if (args is String) {
        //   return MaterialPageRoute(builder: (_) => ItemProfile(data: args));
        // }
        // return _errorRoute();

        break;
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text("Error Route"),
        ),
      );
    });
  }
}
