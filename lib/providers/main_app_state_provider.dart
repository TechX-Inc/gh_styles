import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:gh_styles/models/cart_model.dart';
import 'package:intl/intl.dart';

class MainAppStateProvider with ChangeNotifier {
  final f = new NumberFormat("###.0#", "en_US");
  bool _scrollEnabled = false;

  bool get scrollEnabled => _scrollEnabled;
  Box<CartModel> _cartBox;

  Box<CartModel> get cartBox => _cartBox;

  set setscrollEnabled(bool scrollEnabled) {
    _scrollEnabled = scrollEnabled;
    notifyListeners();
  }

  String computePrice(double discount, double price) {
    String productPrice;
    if (discount <= 0) {
      productPrice = price.toString();
    } else {
      productPrice = (price - (discount / 100) * price).toString();
    }
    return f.format(double.parse(productPrice));
  }
}
