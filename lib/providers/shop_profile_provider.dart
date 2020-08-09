import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/services/products_services.dart';
import 'package:gh_styles/services/shops_services.dart';

class ShopProfileProvider with ChangeNotifier {
  ProductService _productService = new ProductService();
  ShopService _shopService = new ShopService();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  Widget snackBar(error, [color = Colors.red]) => SnackBar(
        content: Text(error),
        backgroundColor: color,
      );

  void deleteProduct(List<dynamic> imageUrl, DocumentReference productRef) {
    _productService.deleteProduct(imageUrl).then((value) {
      if (value == null) {
        Firestore.instance.runTransaction((Transaction tx) async {
          DocumentSnapshot productSnapshot = await tx.get(productRef);
          if (productSnapshot.exists) {
            await tx.delete(productRef).then((value) {
              print("Product Deleted");
            }).then((value) => _scaffoldKey.currentState.showSnackBar(
                snackBar("Product removed", Color.fromRGBO(34, 40, 49, 1))));
          }
        });
      } else {
        switch (value.code) {
          case "IMAGE_NOT_FOUND":
            print("404 image not found");
            Firestore.instance.runTransaction((Transaction tx) async {
              DocumentSnapshot productSnapshot = await tx.get(productRef);
              if (productSnapshot.exists) {
                await tx.delete(productRef).then((value) {
                  print("Product Deleted");
                });
              }
            });
            break;
          case "UNABLE_TO_DELETE_PHOTO":
            print(value.code);
            _scaffoldKey.currentState.showSnackBar(snackBar(value.message));
            break;
          default:
            print("DEFAULT <<<<<<<<<<<<========== $value =========>>>>>>>>>>>");
            _scaffoldKey.currentState
                .showSnackBar(snackBar("An unknown error occured"));
        }
      }
    });
  }

  void deleteShop(String imageUrl, DocumentReference productRef) {
    _shopService.deleteShop(imageUrl).then((value) {
      if (value == true) {
        Firestore.instance.runTransaction((Transaction tx) async {
          DocumentSnapshot productSnapshot = await tx.get(productRef);
          if (productSnapshot.exists) {
            await tx.delete(productRef).then((value) {
              print("Product Deleted");
            }).then((value) => _scaffoldKey.currentState.showSnackBar(
                snackBar("Product removed", Color.fromRGBO(34, 40, 49, 1))));
          }
        });
      } else {
        switch (value.code) {
          case "IMAGE_NOT_FOUND":
            print("404 image not found");
            Firestore.instance.runTransaction((Transaction tx) async {
              DocumentSnapshot productSnapshot = await tx.get(productRef);
              if (productSnapshot.exists) {
                await tx.delete(productRef).then((value) {
                  print("Product Deleted");
                });
              }
            });
            break;
          case "UNABLE_TO_DELETE_PHOTO":
            print(value.code);
            _scaffoldKey.currentState.showSnackBar(snackBar(value.message));
            break;
          default:
            print("DEFAULT <<<<<<<<<<<<========== $value =========>>>>>>>>>>>");
            _scaffoldKey.currentState
                .showSnackBar(snackBar("An unknown error occured"));
        }
      }
    });
  }
}
