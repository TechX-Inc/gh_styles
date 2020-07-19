import 'package:cloud_firestore/cloud_firestore.dart';

class ShopsModel {
  DocumentReference shopRef;
  DocumentReference shopOwnerRef;
  String shopName;
  String shopOwnerLegalName;
  String shopContact;
  String shopEmail;
  String shopLocation;
  String shopWebsite;
  String shopLogoPath;

  ShopsModel(
      {this.shopRef,
      this.shopOwnerRef,
      this.shopName,
      this.shopOwnerLegalName,
      this.shopContact,
      this.shopEmail,
      this.shopLocation,
      this.shopWebsite,
      this.shopLogoPath});

  factory ShopsModel.fromSnapshot(DocumentSnapshot shop) {
    return ShopsModel(
      shopRef: shop.reference,
      shopOwnerRef: shop.data['shop_owner_ref'],
      shopName: shop.data['shop_name'] ?? "",
      shopOwnerLegalName: shop.data['shop_owner_legal_name'] ?? "",
      shopContact: shop.data['shop_contact'] ?? "",
      shopEmail: shop.data['shop_email'] ?? "",
      shopLocation: shop.data['shop_location'] ?? "",
      shopWebsite: shop.data['shop_website'] ?? "",
      shopLogoPath: shop.data['shop_logo'] ?? "",
    );
  }
}
