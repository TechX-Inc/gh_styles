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
  DocumentReference
      favProductRef; // THIS IS THE REFERENCE OF THE PRODUCT THAT WAS ADDED TO FAVOURITES
  DocumentReference userRef;
  DocumentReference
      favRef; // THIS IS THE ACTUAL FAVOURITE DOCUMENT<favProductRef is a field in favRef>

  ProductModel(
      {this.favRef,
      this.userRef,
      this.favProductRef,
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

  factory ProductModel.fromSnapshot(
    DocumentSnapshot product,
  ) {
    return ProductModel(
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

  factory ProductModel.productModelAsFavourite(
    ProductModel product,
  ) {
    return ProductModel(
      productRef: product.productRef,
      productOwner: product.productOwner,
      productName: product.productName,
      productQuantity: product.productQuantity,
      productDescription: product.productDescription,
      productPrice: (product.productPrice).toDouble(),
      productDiscount: (product.productDiscount).toDouble(),
      productType: product.productType,
      gender: product.gender,
      productSize: product.productSize,
      collection: product.collection,
      productPhotos: product.productPhotos ?? [],
    );
  }

  factory ProductModel.asFavourites(
    DocumentSnapshot favourite,
  ) {
    return ProductModel(
        favProductRef: favourite.data['product_ref'] ?? null,
        favRef: favourite.reference,
        userRef: favourite.data['user_ref']);
  }
}
