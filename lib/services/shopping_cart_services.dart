import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:gh_styles/models/cart_model.dart';
import 'package:hive/hive.dart';

class ShoppingCartService {
  CollectionReference _shoppingCart = Firestore.instance.collection("Cart");
  CollectionReference _userCollection = Firestore.instance.collection("Users");
  CollectionReference _products = Firestore.instance.collection("Products");
  final Box _cartBox = Hive.box<CartModel>("cartBox");

//*****************************************************************************************/
//
//*************************************************************************************** */
  Future<QuerySnapshot> checkProductExist(
      String uid, DocumentReference cartProductRef) async {
    return _shoppingCart
        .where('user_ref', isEqualTo: _userCollection.document(uid))
        .where('product_ref', isEqualTo: cartProductRef)
        .getDocuments();
  }

//*****************************************************************************************/
//
//*************************************************************************************** */
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
            .then((value) =>
                updateProductStock(cartProductRef, (-productQuantityAdded)))
            .catchError((onError) => throw new PlatformException(
                code: onError.code, message: onError.message));
      } else {
        print("item added already, updating...");
        updateCart(uid, cartProductRef, productQuantityAdded, selectionPrice)
            .then((value) =>
                updateProductStock(cartProductRef, (-productQuantityAdded)));
      }
    } on PlatformException catch (e) {
      print("Error unable to add favourite");
      return e;
    }
  }

//*****************************************************************************************/
//
//*************************************************************************************** */
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
            print("<<<<<<<==========${onError.message}========>>>>>>");
            return null;
          });
    } on PlatformException catch (e) {
      print("<<<<<<========${e.message}==========>>>>>>");
    }
  }

//*****************************************************************************************/
//
//*************************************************************************************** */
  Future updateProductStock(
      DocumentReference productRef, int productCurrentQuantityStock) async {
    try {
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnapshot =
            await transaction.get(_products.document(productRef.documentID));
        await transaction.update(freshSnapshot.reference, {
          'product_quantity': FieldValue.increment(productCurrentQuantityStock)
        }).then((value) => print("Product updated"));
      }).catchError((error) => throw new PlatformException(
          code: "UPDATE_STOCK_FAILED", message: "failed to update product"));
    } on PlatformException catch (e) {
      print(
          "CANNOT UPDATE PRODUCT STOCK   <<<<<<==================>>>>>>  ${e.message}");
      return e;
    }
  }

//*****************************************************************************************/
//
//*************************************************************************************** */
  Future<dynamic> removeItemFromCart(
      String uid, DocumentReference cartProductRef, int quantityRemoved) async {
    try {
      QuerySnapshot cartProduct = await _shoppingCart
          .where('user_ref', isEqualTo: _userCollection.document(uid))
          .where('product_ref', isEqualTo: cartProductRef)
          .getDocuments();

      return updateProductStock(cartProductRef, quantityRemoved).then((value) {
        return cartProduct.documents[0].reference
            .delete()
            .then((value) => true)
            .catchError((error) => {
                  updateProductStock(cartProductRef, (-quantityRemoved)),
                  throw new PlatformException(
                      code: "REMOVE_ITEM_FAILED",
                      message: "Could not remove item")
                });
      }).catchError((onError) => throw new PlatformException(
          code: "RESTORE_STOCK_FAILED", message: "Error removing item"));
    } on PlatformException catch (e) {
      return e;
    }
  }

//*****************************************************************************************/
//
//*************************************************************************************** */
  Future<dynamic> removeAllFromCart(String uid) async {
    try {
      QuerySnapshot cartProduct = await _shoppingCart
          .where('user_ref', isEqualTo: _userCollection.document(uid))
          .getDocuments();
      if (cartProduct.documents.isNotEmpty) {
        cartProduct.documents.forEach((product) {
          updateProductStock(
                  product.data['product_ref'], product.data['product_quantity'])
              .then((value) {
            product.reference
                .delete()
                .then((value) => true)
                .catchError((error) {
              updateProductStock(product.data['product_ref'],
                  -(product.data['product_quantity']));
              throw new PlatformException(
                  code: "CLEAR_CART_FAILED",
                  message: "Operation failed, please try again");
            });
          }).catchError((error) => throw new PlatformException(
                  code: "RESTORE_STOCK_FAILED",
                  message: "Error restoring stock, please try again"));
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

//*****************************************************************************************/
//
//*****************************************************************************************/
  Future addCartToHive(CartModel cartModel) async {
    final cartProductRef = _products.document(cartModel.productID);
    try {
      if (!_cartBox.containsKey(cartModel.productID)) {
        return _cartBox.put(cartModel.productID, cartModel).then((value) => {
              updateProductStock(cartProductRef, (-cartModel.orderQuantity))
                  .catchError((onError) => throw new PlatformException(
                      code: onError.code, message: onError.message)),
              true
            });
      } else {
        double selectionPrice =
            _cartBox.get(cartModel.productID).selectionPrice as double;
        int orderQuantity = _cartBox.get(cartModel.productID).orderQuantity;
        CartModel cartModelUpdate = CartModel(
          selectionPrice: selectionPrice + cartModel.selectionPrice,
          orderQuantity: orderQuantity + cartModel.orderQuantity,
          productID: cartModel.productID,
          productName: cartModel.productName,
          productQuantity: cartModel.productQuantity,
          productPrice: cartModel.productPrice,
          productDiscount: cartModel.productDiscount,
          productSize: cartModel.productSize,
          productPhotos: cartModel.productPhotos ?? [],
        );

        _cartBox.put(cartModel.productID, cartModelUpdate).then((value) =>
            updateProductStock(cartProductRef, (-cartModel.orderQuantity))
                .catchError((onError) => throw new PlatformException(
                    code: onError.code, message: onError.message)));

        throw new PlatformException(
            code: "DUPLICATE_CART_ITEM",
            message:
                "Adding ${orderQuantity + cartModel.orderQuantity} more item(s) to existing ${cartModel.orderQuantity}");
      }
    } on PlatformException catch (e) {
      return e;
    }
  }

//*****************************************************************************************/
//
//*****************************************************************************************/
  Future clearHiveCart() async {
    try {
      List<CartModel> _cartModelList = _cartBox.values.toList();

      if (_cartModelList.isNotEmpty) {
        _cartModelList.forEach((cartModel) {
          updateProductStock(_products.document(cartModel.productID),
                  cartModel.orderQuantity)
              .then((value) {
            _cartBox.clear().then((value) => true).catchError((error) {
              updateProductStock(_products.document(cartModel.productID),
                  -(cartModel.orderQuantity));
              throw new PlatformException(
                  code: "CLEAR_CART_FAILED",
                  message: "Operation failed, please try again");
            });
          }).catchError((error) => throw new PlatformException(
                  code: "RESTORE_STOCK_FAILED",
                  message: "Error restoring stock, please try again"));
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

//*****************************************************************************************/
//
//*****************************************************************************************/
  Future<dynamic> removeHiveCartItem(
      int index, String cartProductID, int quantityRemoved) async {
    final cartProductRef = _products.document(cartProductID);
    try {
      return updateProductStock(cartProductRef, quantityRemoved).then((value) {
        return _cartBox.deleteAt(index).then((value) => true).catchError(
            (error) => throw new PlatformException(
                code: "REMOVE_CART_FROM_HIVE_FAILED",
                message: "Failed to remove item"));
      }).catchError((onError) => throw new PlatformException(
          code: "RESTORE_STOCK_FAILED", message: "Error removing item"));
    } on PlatformException catch (e) {
      return e;
    }
  }
}
