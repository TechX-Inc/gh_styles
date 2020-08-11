import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/models/shops_model.dart';
import 'package:gh_styles/services/fetch_product_service.dart';
import 'package:rxdart/rxdart.dart';

class FetchShopService extends FetchProductService {
  CollectionReference shops = Firestore.instance.collection("Shops");
  CollectionReference user = Firestore.instance.collection("Users");

  String _uid;

  set setUid(String uid) {
    if (uid != null) {
      _uid = uid;
    }
  }

  Stream<List<ShopsModel>> shopsStream() {
    return shops
        .where("shop_owner_ref", isEqualTo: user.document(_uid))
        .snapshots()
        .map((shopSnapshot) => shopSnapshot.documents
            .map((e) => ShopsModel.fromSnapshot(e))
            .toList());
  }

  Stream<List<ProductModel>> shopProductsStream() {
    return Rx.combineLatest2(super.allProductsStream(), shopsStream(),
        (List<ProductModel> products, List<ShopsModel> shops) {
      return products.map((product) {
        final shopData = shops?.firstWhere(
            (shop) =>
                shop.shopRef.documentID == product.productOwner.documentID,
            orElse: () => null);
        if (shopData != null) {
          return ProductModel.fromSelf(product);
        }
      }).toList();
    });
  }
}
