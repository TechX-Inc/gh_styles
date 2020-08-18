import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/models/cart_model.dart';
import 'package:gh_styles/services/shopping_cart_services.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class ProductDetailsProvider with ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  NumberFormat f = new NumberFormat("###.0#", "en_US");
  final ShoppingCartService _cartService = new ShoppingCartService();
  int _quantityCounter = 1;
  int _quantityInStock;
  double _totalSelectionPrice;
  String _uid;
  DocumentReference _productRef;

  Widget snackBar(error, [color = Colors.red]) => SnackBar(
        content: Text(error),
        backgroundColor: color,
      );

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  int get quantityInStock => _quantityInStock;
  int get quantityCounter => _quantityCounter;

  set setProductStockQuantity(int quantity) {
    if (quantity != null) {
      _quantityInStock = quantity;
    }
  }

  set setUID(String uid) {
    if (uid != null) {
      _uid = uid;
    }
  }

  set setProductRef(DocumentReference productRef) {
    if (productRef != null) {
      _productRef = productRef;
    }
  }

  void increaseQuantity() {
    _quantityCounter += 1;
    if (_quantityCounter >= _quantityInStock) {
      _quantityCounter = _quantityInStock;
    }
    notifyListeners();
  }

  void decreaseQuantity() {
    _quantityCounter -= 1;
    if (_quantityCounter <= 0) {
      _quantityCounter = 1;
    }
    notifyListeners();
  }

//*****************************************************************************************/
//
//*****************************************************************************************/
  String computePrice(double discount, double price) {
    String productPrice;
    if (discount <= 0) {
      productPrice = price.toString();
    } else {
      productPrice = (price - (discount / 100) * price).toString();
    }
    _totalSelectionPrice = double.parse(productPrice) * _quantityCounter;
    return f.format(_totalSelectionPrice);
  }

//*****************************************************************************************/
//
//*****************************************************************************************/
  void addToCart() {
    if (_uid != null) {
      if (_quantityInStock != 0) {
        _cartService
            .addToCart(_uid, _productRef, _quantityCounter, _quantityInStock,
                _totalSelectionPrice)
            .then((value) {
          _quantityInStock -= _quantityCounter;
          notifyListeners();
          Toast.show(
              _quantityCounter > 1
                  ? "$_quantityCounter items added to cart"
                  : "1 item added to cart",
              _scaffoldKey.currentContext,
              duration: 3,
              gravity: Toast.BOTTOM);
        }).timeout(
          Duration(seconds: 8),
          onTimeout: () {
            _scaffoldKey.currentState.showSnackBar(snackBar(
                "Poor internet connection", Color.fromRGBO(144, 12, 63, 1)));
            return null;
          },
        );
      } else {
        print("item out of stock");
        _scaffoldKey.currentState.showSnackBar(
            snackBar("Item out of stock", Color.fromRGBO(227, 99, 135, 1)));
        return null;
      }
    }
  }

//*****************************************************************************************/
//
//*****************************************************************************************/
  Future addCartToHive(CartModel cartModel) async {
    // print(index);
    if (cartModel != null) {
      if (_quantityInStock != 0) {
        _cartService.addCartToHive(cartModel).then((value) {
          _quantityInStock -= _quantityCounter;
          notifyListeners();
          Toast.show(
              _quantityCounter > 1
                  ? "$_quantityCounter items added to cart"
                  : "1 item added to cart",
              _scaffoldKey.currentContext,
              duration: 3,
              gravity: Toast.BOTTOM);
        }).timeout(
          Duration(seconds: 8),
          onTimeout: () {
            _scaffoldKey.currentState.showSnackBar(
                snackBar("Poor internet connection", Colors.orange[300]));
            return null;
          },
        );
      } else {
        print("item out of stock");
        _scaffoldKey.currentState.showSnackBar(
            snackBar("Item out of stock", Color.fromRGBO(227, 99, 135, 1)));
        return null;
      }
    }
  }
}
