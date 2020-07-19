import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  DocumentReference productRef;
  DocumentReference productOwner;
  String productName;
  String productQuantity;
  String productDescription;
  String productPrice;
  String productDiscount;
  String productType;
  String gender;
  String productSize;
  String collection;
  List productPhotos;

  ProductModel(
      {this.productRef,
      this.productOwner,
      this.productName,
      this.productQuantity,
      this.productDescription,
      this.productPrice,
      this.productDiscount,
      this.productType,
      this.gender,
      this.productSize,
      this.collection,
      this.productPhotos});

  factory ProductModel.fromSnapshot(DocumentSnapshot product) {
    return ProductModel(
      productRef: product.reference,
      productOwner: product.data['shop_ref'],
      productName: product.data['product_name'] ?? "",
      productQuantity: product.data['product_quantity'] ?? "",
      productDescription: product.data['product_description'] ?? "",
      productPrice: product.data['product_price'] ?? "",
      productDiscount: product.data['product_discount'] ?? "",
      productType: product.data['categories']['type'] ?? "",
      gender: product.data['categories']['gender'] ?? "",
      productSize: product.data['categories']['size'] ?? "",
      collection: product.data['categories']['collection'] ?? "",
      productPhotos: product.data['product_photos'] ?? [],
    );
  }
}
