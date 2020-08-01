import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gh_styles/models/cart_model.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/services/fetch_product_service.dart';
import 'package:rxdart/rxdart.dart';

class FetchCartService extends FetchProductService {
  CollectionReference _userCollection = Firestore.instance.collection("Users");
  CollectionReference _cart = Firestore.instance.collection("Cart");

  Stream<List<CartModel>> shoppingCart(String uid) {
    return _cart
        .where('user_ref', isEqualTo: _userCollection.document(uid))
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map<CartModel>((product) {
        DocumentReference productRef = product.data['product_ref'];
        return CartModel.fromSnapshot(product, productRef);
      }).toList();
    });
  }

  Stream<List<CartModel>> shoppingCartProductStream(String uid) {
    return Rx.combineLatest2(super.allProductsStream(), shoppingCart(uid),
        (List<ProductModel> products, List<CartModel> carts) {
      return products.map((product) {
        final cartData = carts?.firstWhere(
            (cart) =>
                cart.productRef.documentID == product.productRef.documentID,
            orElse: () => null);
        if (cartData != null) {
          return CartModel.fromProducts(cartData, product);
        }
      }).toList();
    });
  }
}
