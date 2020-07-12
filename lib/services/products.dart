import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:math';

import 'package:gh_styles/test_data.dart';

class ProductService {
  final CollectionReference products =
      Firestore.instance.collection('Products');
  final CollectionReference shopOwner = Firestore.instance.collection("Users");

  DocumentReference shopRef;
  String productName;
  String productQuantity;
  String productDescription;
  String productPrice;
  String productDiscount;
  String productType;
  String gender;
  String productSize;
  String collection;
  File productPhotos;

  ProductService(
      {this.shopRef,
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

  Future newProduct() async {
    try {
      if (shopRef != null &&
          productName != null &&
          productQuantity != null &&
          productDescription != null &&
          productPrice != null) {
        // dynamic downloadPath = await uploadImage(shopLogo);
        return await products.document().setData({
          'shop': shopRef,
          'product_name': productName,
          'product_quantity': productQuantity ?? 1,
          'product_price': productPrice,
          'product_discount': productDiscount ?? 0,
          'product_description': productDescription,
          'date_posted': FieldValue.serverTimestamp(),
          'categories': {
            'type': productType,
            'gender': gender,
            'size': productSize,
            'collection': collection
          }
        }).then((value) async {
          print(
              "=========================>>>>>>>>>>>>> NEW PRODUCT INSERTED <<<<<<<<<<<<================");
          return true;
        }).catchError((onError) => throw new PlatformException(
            code: "PRODUCT_ADD_FAILED", message: "Product was not added"));
      } else {
        throw new PlatformException(
            code: "NULL_IN_REQUIRE_VALUES",
            message: "Some required fields are null");
      }
    } on PlatformException catch (e) {
      print(
          "ADD SHOP PLATFORM EXCEPTION   <<<<<<<<=========${e.code}=========>>>>>>>> ");
      return e.code;
    }
  }

  Future<String> uploadImage(File logo) async {
    if (logo != null) {
      final randomNum = Random(25);
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("businessLogo/${randomNum.nextInt(500000).toString()}.jpg");
      StorageUploadTask task = firebaseStorageRef.putFile(logo);

      dynamic dowurl = await (await task.onComplete).ref.getDownloadURL();
      return dowurl.toString();
    } else {
      print("ERROR UPLOADING FILE");
      return null;
    }
  }
}
