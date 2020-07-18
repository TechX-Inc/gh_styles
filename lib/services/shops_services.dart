import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:math';

class Shop {
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
          shopLocation != null) {
        dynamic downloadPath = await uploadImage(shopLogo);
        return await shops.document().setData({
          'shop_owner': shopOwner.document(uid),
          'shop_name': shopName,
          'shop_contact': shopContact,
          'shop_email': shopEmail,
          'shop_location': shopLocation,
          'shop_logo': downloadPath != null ? downloadPath : "None",
          'shop_website': shopWebsite,
          'date_register': FieldValue.serverTimestamp()
        }).then((value) async {
          print(
              "=========================>>>>>>>>>>>>> DATA INSERTED <<<<<<<<<<<<================");
          await updateHasShopStatus();
          return true;
        }).catchError((onError) => print(
            "ADD SHOP EXCEPTION CAUGHT <<<<<<<<==================>>>>>>>> $onError"));
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      print(
          "ADD SHOP PLATFORM EXCEPTION   <<<<<<<<==================>>>>>>>>  ${e.message}");
      return null;
    }
  }

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
