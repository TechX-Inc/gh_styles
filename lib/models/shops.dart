import 'package:cloud_firestore/cloud_firestore.dart';

class Shops {
  final CollectionReference shops = Firestore.instance.collection('Shops');
  String shopOwner;
  String shopName;
  String shopContact;
  String shopEmail;
  String shopLocation;
  // String shopAvatar;
  String shopWebsite;

  Shops(
      {this.shopOwner,
      this.shopName,
      this.shopContact,
      this.shopEmail,
      this.shopLocation,
      // this.shopAvatar,
      this.shopWebsite});

  Future createShop() async {
    return await shops.document().setData({
      'shop_owner': shopOwner,//should be user reference
      'shop_name': shopName,
      'shop_contact': shopContact,
      'shop_email': shopEmail, 
      'shop_location': shopLocation,    
      'shop_website': shopWebsite,
      'date_register': FieldValue.serverTimestamp()
    });
  }
}
