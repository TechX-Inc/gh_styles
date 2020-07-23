import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gh_styles/models/product_model.dart';

class FetchProductService {
  CollectionReference products = Firestore.instance.collection("Products");

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

  Stream<List<ProductModel>> get allProductsStream {
    return products
        .orderBy("date_posted", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map<ProductModel>((product) => ProductModel.fromSnapshot(product))
          .toList();
    });
  }
}

// Parse product isolate
// List<ProductModel> parseProductOverview(List<DocumentSnapshot> products) {
//   return products
//       .map<ProductModel>((product) => ProductModel.fromSnapshot(product))
//       .toList();
// }
