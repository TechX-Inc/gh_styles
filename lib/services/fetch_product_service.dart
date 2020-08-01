import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gh_styles/models/product_model.dart';

class FetchProductService {
  CollectionReference products = Firestore.instance.collection("Products");
  final CollectionReference _userCollection =
      Firestore.instance.collection("Users");
  final CollectionReference _favourites =
      Firestore.instance.collection("Favourites");

  Stream<List<ProductModel>> productsOverviewStream(String key, String value) {
    return products
        .where("categories.$key", isEqualTo: value)
        .limit(15)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map<ProductModel>((product) => ProductModel.fromSnapshot(product))
          .toList();
    });
  }

  Stream<List<ProductModel>> get newProductsStream {
    return products
        .orderBy("date_posted", descending: true)
        .limit(15)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map<ProductModel>((product) => ProductModel.fromSnapshot(product))
          .toList();
    });
  }

  Stream<List<ProductModel>> allProductsStream() {
    return products
        .orderBy("date_posted", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map<ProductModel>((product) => ProductModel.fromSnapshot(product))
          .toList();
    });
  }

  Stream<List<Stream<ProductModel>>> singleFavouriteProductsStream(
      String uid, DocumentReference favItemRef) {
    return _favourites
        .where('user_ref', isEqualTo: _userCollection.document(uid))
        .where('product_ref', isEqualTo: favItemRef)
        .snapshots()
        .map((querySnap) {
      return querySnap.documents.map((docSnapshot) {
        DocumentReference favRef = docSnapshot.data["product_ref"];
        return favRef.snapshots().map((fav) => ProductModel.fromSnapshot(fav));
      }).toList();
    });
  }

  Stream<List<Stream<ProductModel>>> allFavouriteProductsStream(String uid) {
    return _favourites
        .where('user_ref', isEqualTo: _userCollection.document(uid))
        .snapshots()
        .map((querySnap) {
      return querySnap.documents.map((docSnapshot) {
        DocumentReference favRef = docSnapshot.data["product_ref"];
        return favRef.snapshots().map((fav) => ProductModel.fromSnapshot(fav));
      }).toList();
    });
  }
}
