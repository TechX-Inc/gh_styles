import 'package:flutter/material.dart';
import 'package:gh_styles/providers/cart_provider.dart';
import 'package:gh_styles/screens/auth_screens/forgot.dart';
import 'package:gh_styles/screens/auth_screens/login.dart';
import 'package:gh_styles/screens/auth_screens/register.dart';
import 'package:gh_styles/screens/new_product.dart';
import 'package:gh_styles/screens/main_screen_wrapper.dart';
import 'package:gh_styles/screens/products/product_details.dart';
import 'package:gh_styles/screens/products/shopping_cart.dart';
import 'package:gh_styles/screens/wrapper.dart';
import 'package:gh_styles/screens/splashscreen.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case '/wrapper':
        return MaterialPageRoute(builder: (_) => Wrapper());

      case '/cart':
        return MaterialPageRoute(builder: (_) => ShoppingCart());

      case '/main_screen_wrapper':
        return MaterialPageRoute(builder: (_) => MainScreenWrapper());

      case '/add_product':
        return MaterialPageRoute(builder: (_) => NewProduct());

      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUp());

      case '/login':
        return MaterialPageRoute(builder: (_) => Login());

      case '/forgot_password':
        return MaterialPageRoute(builder: (_) => ForgotPassword());

        // case '/item_details':
        //   return MaterialPageRoute(builder: (_) => DetailsScreen();
        // if (args is String) {
        //   return MaterialPageRoute(builder: (_) => DetailsScreen());
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
