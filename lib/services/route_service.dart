import 'package:flutter/material.dart';
import 'package:gh_styles/screens/auth_screens/forgot.dart';
import 'package:gh_styles/screens/auth_screens/login.dart';
import 'package:gh_styles/screens/auth_screens/signup.dart';
import 'package:gh_styles/screens/item_profile.dart';
import 'package:gh_styles/screens/product_listing.dart';
import 'package:gh_styles/screens/wrapper.dart';
import 'package:gh_styles/screens/splash.dart';
import 'package:gh_styles/ui/screens/home.dart';
import '../main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case '/wrapper':
        return MaterialPageRoute(builder: (_) => Wrapper());

      case '/products':
        return MaterialPageRoute(builder: (_) => HomeScreen());

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
      return SafeArea(
        child: Scaffold(
          body: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/images/error-404_64px.png"),
              Text("Page not found"),
              FlatButton(
                onPressed: () {
                  print("going home");
                },
                child: Text(
                  "Home",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              )
            ],
          )),
        ),
      );
    });
  }
}
