import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  DocumentReference productRef;
  DocumentReference productOwner;
  String productName;
  int productQuantity;
  String productDescription;
  double productPrice;
  double productDiscount;
  String productType;
  String gender;
  String productSize;
  String collection;
  List productPhotos;
  DocumentReference favProductRef;

  ProductModel(
      {this.favProductRef,
      this.productRef,
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

  factory ProductModel.fromSnapshot(DocumentSnapshot product,
      {DocumentReference favProductRef}) {
    return ProductModel(
      favProductRef: favProductRef ?? null,
      productRef: product.reference,
      productOwner: product.data['shop_ref'],
      productName: product.data['product_name'],
      productQuantity: product.data['product_quantity'],
      productDescription: product.data['product_description'],
      productPrice: (product.data['product_price']).toDouble(),
      productDiscount: (product.data['product_discount']).toDouble(),
      productType: product.data['categories']['type'],
      gender: product.data['categories']['gender'],
      productSize: product.data['categories']['size'],
      collection: product.data['categories']['collection'],
      productPhotos: product.data['product_photos'] ?? [],
    );
  }
}
