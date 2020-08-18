import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gh_styles/services/shopping_cart_services.dart';

class CartProvider with ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ShoppingCartService _cartService = new ShoppingCartService();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
// Color.fromRGBO(227, 99, 135, 1)
  Widget snackBar(error, [color = Colors.red]) => SnackBar(
        content: Text(error),
        backgroundColor: color,
      );

  Future<void> removeCartItem(
      String uid, DocumentReference cartProductRef, int quantityRemoved) async {
    await _cartService
        .removeItemFromCart(uid, cartProductRef, quantityRemoved)
        .then((removeCartItem) {
      if (removeCartItem.runtimeType == PlatformException) {
        switch (removeCartItem.code) {
          case "REMOVE_ITEM_FAILED":
            _scaffoldKey.currentState
                .showSnackBar(snackBar(removeCartItem.message));
            break;

          case "RESTORE_STOCK_FAILED":
            _scaffoldKey.currentState
                .showSnackBar(snackBar(removeCartItem.message));
            break;
          default:
            _scaffoldKey.currentState.showSnackBar(
                snackBar("An unknown error occured, please try again"));
        }
      } else if (removeCartItem == true) {
        _scaffoldKey.currentState.showSnackBar(
            snackBar("Item removed", Color.fromRGBO(36, 161, 156, 1)));
      } else {
        _scaffoldKey.currentState
            .showSnackBar(snackBar("An error occured, please try again"));
      }
    }).timeout(
      Duration(seconds: 4),
      onTimeout: () {
        _scaffoldKey.currentState.showSnackBar(
            snackBar("Poor internet connection", Colors.orange[300]));
      },
    );
  }

  Future<void> removeAllFromCart(String uid) async {
    await _cartService.removeAllFromCart(uid).then((clearCart) {
      if (clearCart.runtimeType == PlatformException) {
        switch (clearCart.code) {
          case "EMPTY_CART":
            _scaffoldKey.currentState.showSnackBar(
                snackBar(clearCart.message, Color.fromRGBO(36, 161, 156, 1)));
            break;

          case "CLEAR_CART_FAILED":
            _scaffoldKey.currentState.showSnackBar(snackBar(clearCart.message));
            break;

          case "RESTORE_STOCK_FAILED":
            _scaffoldKey.currentState.showSnackBar(snackBar(clearCart.message));
            break;
          default:
            _scaffoldKey.currentState
                .showSnackBar(snackBar("An unknown error occured, try again"));
        }
      } else if (clearCart == null) {
        print(clearCart);
        _scaffoldKey.currentState.showSnackBar(snackBar(
            "Cart cleared successfully", Color.fromRGBO(36, 161, 156, 1)));
      } else {
        _scaffoldKey.currentState
            .showSnackBar(snackBar("An error occured, please try again"));
      }
    }).timeout(
      Duration(seconds: 4),
      onTimeout: () {
        _scaffoldKey.currentState.showSnackBar(
            snackBar("Poor internet connection", Colors.orange[300]));
      },
    );
  }

  clearHiveCart() {
    _cartService.clearHiveCart().then((clearCart) {
      if (clearCart.runtimeType == PlatformException) {
        switch (clearCart.code) {
          case "EMPTY_CART":
            _scaffoldKey.currentState.showSnackBar(
                snackBar(clearCart.message, Color.fromRGBO(36, 161, 156, 1)));
            break;

          case "CLEAR_CART_FAILED":
            _scaffoldKey.currentState.showSnackBar(snackBar(clearCart.message));
            break;

          case "RESTORE_STOCK_FAILED":
            _scaffoldKey.currentState.showSnackBar(snackBar(clearCart.message));
            break;
          default:
            _scaffoldKey.currentState
                .showSnackBar(snackBar("An unknown error occured, try again"));
        }
      } else if (clearCart == null) {
        print(clearCart);
        _scaffoldKey.currentState.showSnackBar(snackBar(
            "Cart cleared successfully", Color.fromRGBO(36, 161, 156, 1)));
      } else {
        _scaffoldKey.currentState
            .showSnackBar(snackBar("An error occured, please try again"));
      }
    }).timeout(
      Duration(seconds: 4),
      onTimeout: () {
        _scaffoldKey.currentState.showSnackBar(
            snackBar("Poor internet connection", Colors.orange[300]));
      },
    );
  }

  removeHiveCartItem(int index, String cartProductID, int quantityRemoved) {
    _cartService
        .removeHiveCartItem(index, cartProductID, quantityRemoved)
        .then((removeCartItem) {
      if (removeCartItem.runtimeType == PlatformException) {
        switch (removeCartItem.code) {
          case "REMOVE_CART_FROM_HIVE_FAILED":
            _scaffoldKey.currentState
                .showSnackBar(snackBar(removeCartItem.message));
            break;

          case "RESTORE_STOCK_FAILED":
            _scaffoldKey.currentState
                .showSnackBar(snackBar(removeCartItem.message));
            break;
          default:
            _scaffoldKey.currentState.showSnackBar(
                snackBar("An unknown error occured, please try again"));
        }
      } else if (removeCartItem == true) {
        _scaffoldKey.currentState.showSnackBar(
            snackBar("Item removed", Color.fromRGBO(36, 161, 156, 1)));
      } else {
        _scaffoldKey.currentState
            .showSnackBar(snackBar("An error occured, please try again"));
      }
    }).timeout(
      Duration(seconds: 4),
      onTimeout: () {
        _scaffoldKey.currentState.showSnackBar(
            snackBar("Poor internet connection", Colors.orange[300]));
      },
    );
  }
}
