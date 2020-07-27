import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class ProductService {
  final CollectionReference products =
      Firestore.instance.collection('Products');
  final CollectionReference _userCollection =
      Firestore.instance.collection("Users");
  final DocumentReference _productRef =
      Firestore.instance.collection("Products").document();
  final CollectionReference _favourites =
      Firestore.instance.collection("Favourites");

  DocumentReference shopRef;
  List<File> productPhotos;
  String productName;
  int productQuantity;
  String productDescription;
  double productPrice;
  double productDiscount;
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
          productPrice != null) {
        return await _productRef.setData({
          'shop_ref': shopRef,
          'product_name': productName,
          'product_quantity': (productQuantity == null) ? 1 : productQuantity,
          'product_price': productPrice,
          'product_discount': (productDiscount == null) ? 0 : productDiscount,
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
          return await uploadProductPhotos(productPhotos, _productRef)
              .then((value) {
            if (value.runtimeType == PlatformException) {
              return value;
            } else {
              return true;
            }
          });
        }).catchError((onError) => throw new PlatformException(
            code: "PRODUCT_ADD_FAILED", message: "Failed to add product"));
      } else {
        throw new PlatformException(
            code: "NULL_IN_REQUIRED_FIELD",
            message: "Error, fill in all required(*) fields");
      }
    } on PlatformException catch (e) {
      // print(
      //     "ADD SHOP PLATFORM EXCEPTION   <<<<<<<<=========${e.code}=========>>>>>>>> ");
      return e;
    }
  }

/////////////////////UPLOAD PRODUCT PHOTOS/////////////////////////////////
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

          // try {
          StorageUploadTask task = firebaseStorageRef.putFile(imageFile);
          String downloadUrl = await (await task.onComplete)
              .ref
              .getDownloadURL()
              .catchError((error) {
            //DELETE PRODUCT IF GET DOWNLOAD URL FAILS
            productRef.delete();
            firebaseStorageRef
                .child(
                    "productPhotos/${productRef.documentID.toString()}.${basename(imageFile.path)}")
                .delete();
            throw new PlatformException(
                code: "GET_DOWNLOAD_URL_FAILED",
                message: "failed to retrieve images URLs");
          });
          productPhotoDownloadPaths.add(downloadUrl);
          return await productRef
              .updateData({'product_photos': productPhotoDownloadPaths})
              .then((value) => true)
              .catchError((error) {
                deleteProductPhoto(photoUrl: downloadUrl);
                productRef.delete();
                throw new PlatformException(
                    code: "UPDATE_PRODUCT_DOCUMENT_WITH_PHOTO_FAIL",
                    message:
                        "Something went wrong while sending data, please try again");
              });
        });
      } else {
        productRef.delete();
        throw new PlatformException(
            code: "NO_IMAGE_FILE_FOUND",
            message: "missing product image(s), please try again");
      }
    } on PlatformException catch (e) {
      print(e.message);
      return e;
    }
  }

  Future deleteProductPhoto({String photoUrl}) async {
    if (photoUrl != null) {
      StorageReference photoRef = await FirebaseStorage.instance
          .ref()
          .getStorage()
          .getReferenceFromUrl(photoUrl);

      try {
        await photoRef.delete().catchError((error) =>
            throw new PlatformException(
                code: "UNABLE_TO_DELETE_PHOTO",
                message: "Failed to delete product photo"));
      } on PlatformException catch (e) {
        return e;
      }
    }
  }

  Future<QuerySnapshot> checkFavExist(
      String uid, DocumentReference favItemRef) async {
    return _favourites
        .where('user_ref', isEqualTo: _userCollection.document(uid))
        .where('product_ref', isEqualTo: favItemRef)
        .getDocuments();
  }

  Future<void> favoriteProductHandler(
      String uid, DocumentReference favItemRef) async {
    try {
      QuerySnapshot favStatus = await checkFavExist(uid, favItemRef);

      if (favStatus.documents.isEmpty || favStatus.documents.length <= 0) {
        _favourites
            .add({
              'user_ref': _userCollection.document(uid),
              'product_ref': favItemRef,
              'save_date': FieldValue.serverTimestamp(),
            })
            .then((value) => print("Item added to favourites"))
            .catchError((onError) => throw new PlatformException(
                code: onError.code, message: onError.message));
      } else {
        QuerySnapshot favouriteProduct = await _favourites
            .where('user_ref', isEqualTo: _userCollection.document(uid))
            .where('product_ref', isEqualTo: favItemRef)
            .getDocuments();
        favouriteProduct.documents[0].reference
            .delete()
            .then((value) => print("Porduct removed from favoourites..."));
      }
    } on PlatformException catch (e) {
      print("Error unable to add favourite");
      return e.message;
    }
  }
}
