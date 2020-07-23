import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gh_styles/models/shops_model.dart';

class FetchShopService {
  CollectionReference shops = Firestore.instance.collection("Shops");
  CollectionReference user = Firestore.instance.collection("Users");

  String _uid;

  set setUid(String uid) {
    if (uid != null) {
      _uid = uid;
    }
  }

  Stream<List<ShopsModel>> get shopsStream {
    return shops
        .where("shop_owner_ref", isEqualTo: user.document(_uid))
        .snapshots()
        .map((shopSnapshot) => shopSnapshot.documents
            .map((e) => ShopsModel.fromSnapshot(e))
            .toList());

    // print(shopSnapshot);
  }
}
