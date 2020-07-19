import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class ProductService {
  final CollectionReference products =
      Firestore.instance.collection('Products');
  final CollectionReference shopOwner = Firestore.instance.collection("Users");
  final DocumentReference _productRef =
      Firestore.instance.collection("Products").document();

  DocumentReference shopRef;
  List<File> productPhotos;
  String productName;
  String productQuantity;
  String productDescription;
  String productPrice;
  String productDiscount;
  String productType;
  String gender;
  String productSize;
  String collection;

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
          productPrice != null &&
          productPhotos != null) {
        print("Sending data...");
        // dynamic downloadPath = await uploadProductPhotos(shopLogo);
        return await _productRef.setData({
          'shop_ref': shopRef,
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
          },
          'product_photos': null
        }).then((value) async {
          print("PRODUCTS ADDED, sending image data....");
          dynamic storePhoto =
              await uploadProductPhotos(productPhotos, _productRef);
          return storePhoto;
        }).catchError((onError) => throw new PlatformException(
            code: "PRODUCT_ADD_FAILED", message: "Product was not added"));
      } else {
        throw new PlatformException(
            code: "NULL_IN_REQUIRED_FIELD",
            message: "Some required fields are null");
      }
    } on PlatformException catch (e) {
      print(
          "ADD SHOP PLATFORM EXCEPTION   <<<<<<<<=========${e.code}=========>>>>>>>> ");
      return e.code;
    }
  }

  Future<dynamic> uploadProductPhotos(
      List<File> productPhoto, DocumentReference productRef) async {
    try {
      if (productPhoto != null && productPhoto.isNotEmpty) {
        List<String> productPhotoDownloadPaths = [];
        productPhoto.forEach((imageFile) async {
          StorageReference firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child(
                  "productPhotos/${productRef.documentID.toString()}.${basename(imageFile.path)}");
          StorageUploadTask task = firebaseStorageRef.putFile(imageFile);
          return await (await task.onComplete)
              .ref
              .getDownloadURL()
              .then((value) async {
            productPhotoDownloadPaths.add(value);
            return await productRef
                .updateData({'product_photos': productPhotoDownloadPaths})
                .then((value) => true)
                .catchError((error) => throw new PlatformException(
                    code: "UPDATE_PRODUCT_DOCUMENT_WITH_PHOTO_FAIL",
                    message: "unable to update document with download paths"));
          }).catchError((error) => {
                    throw new PlatformException(
                        code: "PRODUCT_IMAGE_UPLOAD_FAIL",
                        message: "failed to upload product photos"),
                    //DELETE PRODUCT IF PHOTO UPLOAD FAILS
                    productRef.delete()
                  });
        });
        return true;
      } else {
        // print("ERROR UPLOADING FILE");
        throw new PlatformException(
            code: "NULL_OR_EMPTY_PRODUCT_PHOTO",
            message: "no image data found");
      }
    } on PlatformException catch (e) {
      print(e.message);
      return e.code;
    }
  }
}
