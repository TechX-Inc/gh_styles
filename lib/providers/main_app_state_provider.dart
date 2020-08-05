import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:gh_styles/models/cart_model.dart';

class MainAppStateProvider with ChangeNotifier {
  bool _scrollEnabled = false;

  bool get scrollEnabled => _scrollEnabled;
  Box<CartModel> _cartBox;

  Box<CartModel> get cartBox => _cartBox;

  set setscrollEnabled(bool scrollEnabled) {
    _scrollEnabled = scrollEnabled;
    notifyListeners();
  }
}
