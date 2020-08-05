import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:hive/hive.dart';
part 'cart_model.g.dart';

@HiveType(typeId: 1)
class CartModel {
//*****************************************************************************************/
//
//*************************************************************************************** */
  @HiveField(0)
  int orderQuantity;
  @HiveField(1)
  String productID;
  DocumentReference cartRef;
  DocumentReference productRef;
  @HiveField(2)
  double selectionPrice;
  @HiveField(3)
  String productName;
  @HiveField(4)
  int productQuantity;
  @HiveField(5)
  String productSize;
  @HiveField(6)
  double productPrice;
  @HiveField(7)
  double productDiscount;
  @HiveField(8)
  List productPhotos;

  CartModel({
    this.productID,
    this.productRef,
    this.productName,
    this.productDiscount,
    this.productPrice,
    this.productPhotos,
    this.productSize,
    this.productQuantity,
    this.orderQuantity,
    this.cartRef,
    this.selectionPrice,
  });

//*****************************************************************************************/
//
//*************************************************************************************** */
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

//*****************************************************************************************/
//
//*************************************************************************************** */
  factory CartModel.fromSnapshot(
      DocumentSnapshot snapshot, DocumentReference productRef) {
    return CartModel(
      productRef: productRef,
      cartRef: snapshot.reference,
      selectionPrice: snapshot.data['price'],
      orderQuantity: snapshot.data['product_quantity'],
    );
  }

//*****************************************************************************************/
//
//*************************************************************************************** */
  factory CartModel.toHive(
      int quantity, double selectionPrice, ProductModel productModel) {
    return CartModel(
      selectionPrice: selectionPrice,
      orderQuantity: quantity,
      productID: productModel.productRef.documentID,
      productName: productModel.productName,
      productQuantity: productModel.productQuantity,
      productPrice: productModel.productPrice,
      productDiscount: productModel.productDiscount,
      productSize: productModel.productSize,
      productPhotos: productModel.productPhotos ?? [],
    );
  }
}
