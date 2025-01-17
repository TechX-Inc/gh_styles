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

  Future<dynamic> newProduct() async {
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
          'product_discount': productDiscount,
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
      return e;
    }
  }

//////////////////////////////////////// EDIT PRODUCT //////////////////////////////////////////////
  Future<dynamic> editProduct(DocumentReference targetProduct,
      List<dynamic> productCurrentImages) async {
    try {
      if (productName != null &&
          productQuantity != null &&
          productDescription != null &&
          productPrice != null) {
        return await targetProduct.updateData({
          'product_name': productName,
          'product_quantity': (productQuantity == null) ? 1 : productQuantity,
          'product_price': productPrice,
          'product_discount': (productDiscount == null) ? 0 : productDiscount,
          'product_description': productDescription,
          'categories': {
            'type': productType,
            'gender': gender,
            'size': productSize,
            'collection': collection
          },
          'product_photos': productCurrentImages
        }).then((value) async {
          print("PRODUCTS UPDATED, updating image data....");
          return await updateProductPhotos(targetProduct).then((value) {
            // print("VALUE AFTER F-STORAGE ========== $value =========");
            if (value.runtimeType == PlatformException) {
              return value;
            } else {
              return true;
            }
          });
        }).catchError((onError) => throw new PlatformException(
            code: "PRODUCT_UPDATE_FAILED",
            message: "Failed to update product"));
      } else {
        throw new PlatformException(
            code: "NULL_IN_REQUIRED_FIELD",
            message: "Error, fill in all required(*) fields");
      }
    } on PlatformException catch (e) {
      return e;
    }
  }

//////////////////////////////////UPLOAD PRODUCT PHOTOS////////////////////////////////////////////
  Future<dynamic> updateProductPhotos(DocumentReference productRef) async {
    try {
      if (productPhotos != null && productPhotos.isNotEmpty) {
        // Meaning user wants to add new image to existing ones
        // List<String> productPhotoDownloadPaths = [];
        productPhotos.forEach((imageFile) async {
          StorageReference firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child(
                  "productPhotos/${productRef.documentID.toString()}.${basename(imageFile.path)}");

          StorageUploadTask task = firebaseStorageRef.putFile(imageFile);
          return await (await task.onComplete)
              .ref
              .getDownloadURL()
              .catchError((error) {
            //DELETE PRODUCT IMAGE FROM F-STORAGE IF UNABLE TO GET DOWNLOAD URL
            firebaseStorageRef
                .child(
                    "productPhotos/${productRef.documentID.toString()}.${basename(imageFile.path)}")
                .delete();
            throw new PlatformException(
                code: "GET_DOWNLOAD_URL_FAILED",
                message: "Operation failed, unable to send image(s)");
          }).then((downloadUrl) async {
            // productPhotoDownloadPaths.add(downloadUrl);
            // print(downloadUrl);
            return await productRef
                .updateData({
                  'product_photos': FieldValue.arrayUnion([downloadUrl])
                })
                .then((value) => true)
                .catchError((error) {
                  print("============== CODE ${error.code} ===========");
                  // DELETE PRODUCT IMAGE FROM F-STORAGE IF UNABLE TO UPDATE DOCUMENT IN DATABASE WITH DOWNLOAD URL
                  deleteProductPhoto(photoUrl: downloadUrl);
                  throw new PlatformException(
                      code: "UPDATE_PRODUCT_DOCUMENT_WITH_PHOTO_FAIL",
                      message:
                          "An error occured while sending data, please try again");
                });
          });
        });
      } else {
        // Means no image was selected, therefore we maintain existing images for the particular product
        return true;
      }
    } on PlatformException catch (e) {
      print("============= ${e.message} ===============");
      return e;
    }
  }

//////////////////////////////////UPLOAD PRODUCT PHOTOS////////////////////////////////////////////
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

//////////////////////////////////////////// DELETE PHOTO FROM FIREBASE STORAGE ///////////////////////////
  Future<dynamic> deleteProductPhoto({String photoUrl}) async {
    if (photoUrl != null) {
      try {
        return await FirebaseStorage.instance
            .ref()
            .getStorage()
            .getReferenceFromUrl(photoUrl)
            .then((photoRef) async {
              return await photoRef
                  .delete()
                  .catchError((error) => throw new PlatformException(
                      code: "UNABLE_TO_DELETE_PHOTO",
                      message: "Failed to remove photo"))
                  .then((value) => true);
            })
            .then((value) => true)
            .catchError((error) => {
                  throw new PlatformException(
                      code: "IMAGE_NOT_FOUND",
                      message: "Could not find image file")
                });
      } on PlatformException catch (e) {
        return e;
      }
    }
  }

///////////////////////////// CHECK IF USER HAS ALREADY ADDED PRODUCT TO FAVOURITES ///////////////////////
  Future<QuerySnapshot> checkFavExist(
      String uid, DocumentReference favItemRef) async {
    return _favourites
        .where('user_ref', isEqualTo: _userCollection.document(uid))
        .where('product_ref', isEqualTo: favItemRef)
        .getDocuments();
  }

///////////////////////// ADD FAVOURITE ////////////////////////////////////
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
      print("======= ${e.code} =========");

      return e.message;
    }
  }

  Future<dynamic> deleteProduct(List<dynamic> imagesUrl) async {
    try {
      imagesUrl.forEach((url) {
        deleteProductPhoto(photoUrl: url)
            .then((value) => true)
            .catchError((error) {
          throw new PlatformException(code: "UNABLE_TO_REMOVE_IMAGE");
        });
      });
    } on PlatformException catch (e) {
      return e;
    }
  }
}
