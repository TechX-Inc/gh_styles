import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/services/shopping_cart_services.dart';

class CartProvider with ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ShoppingCartService _cartService = new ShoppingCartService();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  Widget snackBar(error, [color = Colors.red]) => SnackBar(
        content: Text(error),
        backgroundColor: color,
      );

  void removeCartItem(String uid, DocumentReference cartProductRef) {
    _cartService
        .removeItemFromCart(uid, cartProductRef)
        .then((value) => _scaffoldKey.currentState.showSnackBar(
            snackBar("Item removed", Color.fromRGBO(67, 216, 201, 1))))
        .catchError((error) =>
            _scaffoldKey.currentState.showSnackBar(snackBar(error.message)));
    ;
  }

  Future<void> removeAllFromCart(String uid) async {
    dynamic clearCart = await _cartService.removeAllFromCart(uid);
    if (clearCart != null) {
      switch (clearCart.code) {
        case "EMPTY_CART":
          _scaffoldKey.currentState.showSnackBar(snackBar(clearCart.message));
          break;
        default:
          _scaffoldKey.currentState.showSnackBar(snackBar(clearCart.message));
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(snackBar(
          "Cart successfully cleared", Color.fromRGBO(67, 216, 201, 1)));
    }
  }
}
