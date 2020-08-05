import 'package:flutter/material.dart';
import 'package:gh_styles/providers/product_details_provider.dart';
import 'package:gh_styles/screens/add_shop.dart';
import 'package:gh_styles/screens/auth_screens/login.dart';
import 'package:gh_styles/screens/auth_screens/register.dart';
import 'package:gh_styles/screens/add_product.dart';
import 'package:gh_styles/screens/main_screen_wrapper.dart';
import 'package:gh_styles/screens/products/product_details.dart';
import 'package:gh_styles/screens/products/shopping_cart.dart';
import 'package:gh_styles/screens/wrapper.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // case '/':
      //   return MaterialPageRoute(builder: (_) => SplashScreen());

      case '/':
        return MaterialPageRoute(builder: (_) => Wrapper());

      case '/main_screen_wrapper':
        return MaterialPageRoute(builder: (_) => MainScreenWrapper());

      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUp());

      case '/login':
        return MaterialPageRoute(builder: (_) => Login());

      case '/cart':
        return MaterialPageRoute(builder: (_) => ShoppingCart());

      case '/add_product':
        return MaterialPageRoute(builder: (_) => AddProduct());

      case '/edit_product':
        if (args is Map) {
          return MaterialPageRoute(
              builder: (_) => AddProduct(
                    editMode: args["edit_mode"],
                    productModel: args["product_model"],
                  ));
        }
        return _errorRoute();

      case '/edit_shop':
        if (args is Map) {
          return MaterialPageRoute(
              builder: (_) => AddShop(
                    editMode: args["edit_mode"],
                    shopsModel: args["shop_model"],
                  ));
        }
        return _errorRoute();

      case '/product_details':
        if (args is Map) {
          return MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider<ProductDetailsProvider>(
                  create: (context) => ProductDetailsProvider(),
                  builder: (context, data) {
                    return DetailsScreen(
                      productModel: args["product_model"],
                      heroID: args["hero_id"],
                      index: args["index"],
                    );
                  }));
        }
        return _errorRoute();

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
