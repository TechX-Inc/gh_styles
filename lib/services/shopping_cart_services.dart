import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ShoppingCartService {
  CollectionReference _shoppingCart = Firestore.instance.collection("Cart");
  CollectionReference _userCollection = Firestore.instance.collection("Users");
  CollectionReference _products = Firestore.instance.collection("Products");
  DocumentReference _cartRef = Firestore.instance.collection("Cart").document();

  Future<QuerySnapshot> checkProductExist(
      String uid, DocumentReference cartProductRef) async {
    return _shoppingCart
        .where('user_ref', isEqualTo: _userCollection.document(uid))
        .where('product_ref', isEqualTo: cartProductRef)
        .getDocuments();
  }

  Future<void> addToCart(String uid, DocumentReference cartProductRef,
      int productQuantityAdded, int productQuantityStock) async {
    try {
      QuerySnapshot cartItem = await checkProductExist(uid, cartProductRef);
      if (cartItem.documents.isEmpty || cartItem.documents.length <= 0) {
        _cartRef
            .setData({
              'user_ref': _userCollection.document(uid),
              'product_ref': cartProductRef,
              'product_quantity': productQuantityAdded,
              'save_date': FieldValue.serverTimestamp(),
            })
            .then((value) => updateProduct(cartProductRef,
                (productQuantityStock - productQuantityAdded).toString()))
            .catchError((onError) => throw new PlatformException(
                code: onError.code, message: onError.message));
      } else {
        updateCart(productQuantityAdded);
      }
    } on PlatformException catch (e) {
      print("Error unable to add favourite");
      return e.message;
    }
  }

  void updateCart(int productQuantity) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnapshot = await transaction.get(_cartRef);
        await transaction.update(
            freshSnapshot.reference, {'product_quantity': productQuantity});
      }).catchError((onError) {
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
      DocumentReference productRef, String productCurrentQuantityStock) {
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

  Future<void> removeFromCart(
      String uid, DocumentReference cartProductRef) async {
    QuerySnapshot favouriteProduct = await _shoppingCart
        .where('user_ref', isEqualTo: _userCollection.document(uid))
        .where('product_ref', isEqualTo: cartProductRef)
        .getDocuments();
    favouriteProduct.documents[0].reference
        .delete()
        .then((value) => print("Porduct removed from favoourites..."));
  }
}
