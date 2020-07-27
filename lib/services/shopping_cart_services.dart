import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ShoppingCartService {
  CollectionReference _shoppingCart = Firestore.instance.collection("Cart");
  CollectionReference _userCollection = Firestore.instance.collection("Users");
  CollectionReference _products = Firestore.instance.collection("Products");
  // DocumentReference _cartRef = Firestore.instance.collection("Cart").document();

  Future<QuerySnapshot> checkProductExist(
      String uid, DocumentReference cartProductRef) async {
    return _shoppingCart
        .where('user_ref', isEqualTo: _userCollection.document(uid))
        .where('product_ref', isEqualTo: cartProductRef)
        .getDocuments();
  }

  Future<void> addToCart(
      String uid,
      DocumentReference cartProductRef,
      int productQuantityAdded,
      int productQuantityStock,
      double selectionPrice) async {
    try {
      QuerySnapshot cartItem = await checkProductExist(uid, cartProductRef);
      if (cartItem.documents.isEmpty || cartItem.documents.length <= 0) {
        _shoppingCart
            .add({
              'user_ref': _userCollection.document(uid),
              'product_ref': cartProductRef,
              'product_quantity': productQuantityAdded,
              'price': selectionPrice,
              'save_date': FieldValue.serverTimestamp(),
            })
            .then((value) => updateProduct(
                cartProductRef, (productQuantityStock - productQuantityAdded)))
            .catchError((onError) => throw new PlatformException(
                code: onError.code, message: onError.message));
      } else {
        print("item added already, updating...");
        updateCart(uid, cartProductRef, productQuantityAdded, selectionPrice)
            .then((value) => updateProduct(
                cartProductRef, (productQuantityStock - productQuantityAdded)));
      }
    } on PlatformException catch (e) {
      print("Error unable to add favourite");
      return e.message;
    }
  }

  Future<void> updateCart(String uid, DocumentReference cartProductRef,
      int productQuantity, double selectionPrice) async {
    try {
      QuerySnapshot cartProduct = await _shoppingCart
          .where('user_ref', isEqualTo: _userCollection.document(uid))
          .where('product_ref', isEqualTo: cartProductRef)
          .getDocuments();

      Firestore.instance
          .runTransaction((transaction) async {
            DocumentSnapshot freshSnapshot =
                await transaction.get(cartProduct.documents[0].reference);
            await transaction.update(freshSnapshot.reference, {
              'product_quantity': FieldValue.increment(productQuantity),
              'price': FieldValue.increment(selectionPrice)
            });
          })
          .then((value) => print("Cart updated"))
          .catchError((onError) {
            print(
                "UNABLE TO UPDATE SHOP STATUS   <<<<<<<==================>>>>>>  ${onError.message}");
            return null;
          });
    } on PlatformException catch (e) {
      print(
          "CANNOT UPDATE SHOP STATUS   <<<<<<==================>>>>>>  ${e.message}");
    }
  }

  void updateProduct(
      DocumentReference productRef, int productCurrentQuantityStock) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnapshot =
            await transaction.get(_products.document(productRef.documentID));
        await transaction.update(freshSnapshot.reference, {
          'product_quantity': productCurrentQuantityStock
        }).then((value) => print("Item added to cart"));
      }).catchError((onError) {
        print(
            "UNABLE TO UPDATE PRODUCT QUANTITY  <<<<<<<==================>>>>>>  ${onError.message}");
        return null;
      });
    } on PlatformException catch (e) {
      print(
          "CANNOT UPDATE SHOP STATUS   <<<<<<==================>>>>>>  ${e.message}");
    }
  }

  Future<dynamic> removeItemFromCart(
      String uid, DocumentReference cartProductRef) async {
    try {
      QuerySnapshot cartProduct = await _shoppingCart
          .where('user_ref', isEqualTo: _userCollection.document(uid))
          .where('product_ref', isEqualTo: cartProductRef)
          .getDocuments();
      cartProduct.documents[0].reference
          .delete()
          .then((value) => print("Item removed from cart..."))
          .catchError((error) => throw new PlatformException(
              code: "REMOVE_ITEM_FAILED", message: "Could not remove item"));
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<dynamic> removeAllFromCart(String uid) async {
    try {
      QuerySnapshot cartProduct = await _shoppingCart
          .where('user_ref', isEqualTo: _userCollection.document(uid))
          .getDocuments();
      if (cartProduct.documents.isNotEmpty) {
        cartProduct.documents.forEach((product) {
          product.reference.delete().then((value) => true).catchError((error) =>
              throw new PlatformException(
                  code: "CLEAR_CART_FAILED",
                  message: "Failed to clear cart, please try again"));
        });
      } else {
        print("CART EMPTY");
        throw new PlatformException(
            code: "EMPTY_CART", message: "Your cart is empty");
      }
    } on PlatformException catch (e) {
      return e;
    }
  }
}
