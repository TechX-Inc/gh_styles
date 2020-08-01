import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gh_styles/models/product_model.dart';

class CartModel extends ProductModel {
  int orderQuantity;
  DocumentReference cartRef;
  double selectionPrice;

  CartModel({
    DocumentReference productRef,
    String productName,
    int productQuantity,
    String productSize,
    double productPrice,
    double productDiscount,
    List productPhotos,
    this.orderQuantity,
    this.cartRef,
    this.selectionPrice,
  }) : super(
            productRef: productRef,
            productName: productName,
            productQuantity: productQuantity,
            productPrice: productPrice,
            productDiscount: productDiscount,
            productPhotos: productPhotos,
            productSize: productSize);

  factory CartModel.fromProducts(
      CartModel cartModel, ProductModel productModel) {
    return CartModel(
      cartRef: cartModel.cartRef,
      selectionPrice: cartModel.selectionPrice,
      orderQuantity: cartModel.orderQuantity,
      productRef: productModel.productRef,
      productName: productModel.productName,
      productQuantity: productModel.productQuantity,
      productPrice: productModel.productPrice,
      productDiscount: productModel.productDiscount,
      productSize: productModel.productSize,
      productPhotos: productModel.productPhotos ?? [],
    );
  }

  factory CartModel.fromSnapshot(
      DocumentSnapshot snapshot, DocumentReference productRef) {
    return CartModel(
      productRef: productRef,
      cartRef: snapshot.reference,
      selectionPrice: snapshot.data['price'],
      orderQuantity: snapshot.data['product_quantity'],
    );
  }
}
