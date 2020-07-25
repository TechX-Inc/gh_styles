import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class Shop {
  DocumentReference shopRef = Firestore.instance.collection("Shops").document();
  final CollectionReference shops = Firestore.instance.collection('Shops');
  final CollectionReference shopOwner = Firestore.instance.collection("Users");

  String uid;
  String shopName;
  String shopOwnerLegalName;
  String shopContact;
  String shopEmail;
  String shopLocation;
  String shopWebsite;
  File shopLogo;

  Shop(
      {this.uid,
      this.shopName,
      this.shopOwnerLegalName,
      this.shopContact,
      this.shopEmail,
      this.shopLocation,
      this.shopWebsite,
      this.shopLogo});

  Future createShop() async {
    try {
      if (uid != null &&
          shopName != null &&
          shopOwnerLegalName != null &&
          shopContact != null &&
          shopEmail != null &&
          shopLogo != null &&
          shopLocation != null) {
        return await shopRef.setData({
          'shop_owner_ref': shopOwner.document(uid),
          'shop_name': shopName,
          'shop_contact': shopContact,
          'shop_email': shopEmail,
          'shop_location': shopLocation,
          'shop_logo': null,
          'shop_owner_legal_name': shopOwnerLegalName,
          'shop_website': shopWebsite,
          'date_register': FieldValue.serverTimestamp()
        }).then((value) async {
          print(
              "=========================>>>>>>>>>>>>> DATA INSERTED, SENDING LOGO DATA <<<<<<<<<<<<================");
          dynamic logo = await uploadLogoImage(shopLogo);
          print("===================$logo=================");
          if (logo == true) {
            await updateHasShopStatus();
            return true;
          }
        }).catchError((onError) => throw new PlatformException(
            code: "FAILED_TO_CREATE_SHOP",
            message: "failed to create shop, please try again"));
      } else {
        throw new PlatformException(
            code: "NULL_REQUIRED_FIELD",
            message: "Please fill all required(*) fields");
      }
    } on PlatformException catch (e) {
      return e;
    }
  }

  // ignore: missing_return
  Future updateHasShopStatus() {
    try {
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnapshot =
            await transaction.get(shopOwner.document(uid));
        await transaction.update(freshSnapshot.reference, {'has_shop': true});
      }).catchError((onError) {
        print(
            "UNABLE TO UPDATE SHOP STATUS   <<<<<<<==================>>>>>>  ${onError.message}");
        return null;
      });
    } on PlatformException catch (e) {
      print(
          "CANNOT UPDATE SHOP STATUS   <<<<<<==================>>>>>>  ${e.message}");
    }
  }

  Future<dynamic> uploadLogoImage(File logoFile) async {
    try {
      if (logoFile != null) {
        StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(
            "businessLogo/${shopRef.documentID.toString()}.${basename(logoFile.path)}");
        StorageUploadTask task = firebaseStorageRef.putFile(logoFile);

        return await (await task.onComplete)
            .ref
            .getDownloadURL()
            .then((downloadPath) async {
          return await shopRef
              .updateData({'shop_logo': downloadPath})
              .then((value) => true)
              .catchError((error) => {
                    throw new PlatformException(
                        code: "UPDATE_SHOP_DOCUMENT_LOGO_FAIL",
                        message: "Failed to store image path")
                  });
        }).catchError((error) {
          //DELETE SHOP IF PHOTO UPLOAD FAILS
          shopRef.delete().then((value) {
            shopOwner
                .document(uid)
                .updateData({'has_shop': false})
                .then((value) => true)
                .catchError((error) => {
                      throw new PlatformException(
                          code: "SET_SHOP_OWNER_FALSE_FAILED",
                          message: "Failed to update shop owner status")
                    });
          });
          throw new PlatformException(
              code: "SHOP_LOGO_UPLOAD_FAIL",
              message: "Failed to upload logo image file");
        });
      } else {
        shopRef.delete().then((value) {
          shopOwner
              .document(uid)
              .updateData({'has_shop': false})
              .then((value) => true)
              .catchError((error) => {
                    throw new PlatformException(
                        code: "SET_SHOP_OWNER_FALSE_FAILED",
                        message: "Error while disabling shop")
                  });
        });

        throw new PlatformException(
            code: "NULL_IMAGE_FILE", message: "Image file was not found");
      }
    } on PlatformException catch (e) {
      return e;
    }
  }
}