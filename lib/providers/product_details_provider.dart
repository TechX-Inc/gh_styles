import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gh_styles/services/shopping_cart_services.dart';
import 'package:intl/intl.dart';

class ProductDetailsProvider with ChangeNotifier {
  NumberFormat f = new NumberFormat("###.0#", "en_US");
  final ShoppingCartService _cartService = new ShoppingCartService();
  int _quantityCounter = 1;
  int _quantityInStock;
  double _itemUnitPrice;
  String _uid;
  DocumentReference _productRef;

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

  String computePrice(String discountString, String priceString) {
    double discount = double.parse(discountString);
    double price = double.parse(priceString);
    String productPrice;
    if (discount <= 0) {
      productPrice = price.toString();
    } else {
      productPrice = (price - (discount / 100) * price).toString();
    }
    _itemUnitPrice = double.parse(productPrice) * _quantityCounter;
    return f.format(_itemUnitPrice);
  }

  void addToCart(BuildContext contexts) {
    _cartService.addToCart(
        _uid, _productRef, _quantityCounter, _quantityInStock);
  }
}
