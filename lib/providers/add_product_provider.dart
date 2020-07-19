import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gh_styles/auth_and_validation/auth_service.dart';
import 'package:gh_styles/services/products_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:toast/toast.dart';

class AddProductProvider with ChangeNotifier {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStepperOne = GlobalKey<FormState>();

  final AuthService _auth = new AuthService();
  List<File> _images = List();
  bool _loading = false;

  Widget snackBar(error, [color = Colors.red]) => SnackBar(
        content: Text(error),
        backgroundColor: color,
      );

  CollectionReference user = Firestore.instance.collection("Users");
  CollectionReference shop = Firestore.instance.collection("Shops");

  String _uid;

  String _productName;
  String _productQuantity;
  String _productDescription;
  String _productPrice;
  String _productDiscount;
  String _productType = 'Footwears';
  String _gender = 'Male';
  String _productSize;
  String _collection = 'Kids';

//GETTERS
  GlobalKey<FormState> get formKey => _formKey;
  GlobalKey<FormState> get formKeyStepperOne => _formKeyStepperOne;

  AuthService get auth => _auth;
  bool get loading => _loading;

  List<File> get images => _images;

  String get productType => _productType;
  String get gender => _gender;
  String get collection => _collection;

//SETTERS
  set setproductName(String productName) {
    _productName = productName;
  }

  set setproductQuantity(String productQuantity) {
    _productQuantity = productQuantity;
  }

  set setproductPrice(String productPrice) {
    _productPrice = productPrice;
  }

  set setproductDiscount(String productDiscount) {
    _productDiscount = productDiscount;
  }

  set setproductDescription(String productDescription) {
    _productDescription = productDescription;
  }

  set setproductType(String productType) {
    _productType = productType;
    notifyListeners();
  }

  set setgender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  set setproductSize(String productSize) {
    _productSize = productSize;
  }

  set setcollection(String collection) {
    _collection = collection;
    notifyListeners();
  }

  set setUID(String uid) {
    _uid = uid;
  }

  set imageToRemoveIndex(int index) {
    _images.removeAt(index);
    notifyListeners();
  }

  Future<dynamic> findShop() async {
    DocumentReference shopRef;
    try {
      shopRef = await shop
          .where('shop_owner', isEqualTo: shopRef)
          .getDocuments()
          .then((value) {
        if (value.documents.length > 0 && value != null) {
          shopRef = value?.documents[0]?.reference;
          return shopRef;
        } else {
          throw new PlatformException(
              code: "SHOP_REF_ISNULL", message: "Shop reference is null");
        }
      }).catchError((onError) => throw new PlatformException(
              code: onError.code, message: onError.message));
    } on PlatformException catch (e) {
      print(
          "<<<<<<<<================${e.message}==================>>>>>>>>>>>");
      return e.code;
    }
    return shopRef;
  }

  Future getShopData() async {
    dynamic shopRef = await findShop();
    return await shopRef.get().then((shopData) => shopData.data);
  }

  Future<void> processAndSave(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      if (_images.isNotEmpty) {
        _formKey.currentState.save();
        _loading = true;
        notifyListeners();

        dynamic shopRef = await findShop();
        if (shopRef.runtimeType != DocumentReference) {
          print(shopRef);
          Scaffold.of(context)
              .showSnackBar(snackBar("An unexpected error occured"));
          _loading = false;
          notifyListeners();
        } else {
          // print("NAME $_productName");
          // print("QUANTITY $_productQuantity");
          // print("DESCRIPTION $_productDescription");
          // print("DISCOUNT $_productDiscount");
          // print("PRICE $_productPrice");
          // print("TYPE $_productType");
          // print("SIZE $_productSize");
          // print("GENDER $_gender");
          // print("COLLECTION $_collection");

          ProductService newProduct = new ProductService(
              shopRef: shopRef,
              productPhotos: _images.isNotEmpty ? _images : null,
              productName: _productName.trim() ?? null,
              productQuantity: _productQuantity.trim() ?? 1.toString(),
              productDescription: _productDescription ?? '',
              productDiscount: _productDiscount ?? 0.toString(),
              productPrice: _productPrice.trim() ?? null,
              productType: _productType.trim(),
              productSize: _productSize ?? null,
              gender: _gender.trim(),
              collection: _collection.trim());
          dynamic product = await newProduct.newProduct();
          print(product);
          if (product != true) {
            switch (product) {
              case "NULL_IN_REQUIRED_FIELD":
                Scaffold.of(context).showSnackBar(
                    snackBar("Error, provide all required(*) fields"));
                _loading = false;
                notifyListeners();
                break;

              case "PRODUCT_ADD_FAILED":
                Scaffold.of(context)
                    .showSnackBar(snackBar("Unable to add product"));
                _loading = false;
                notifyListeners();
                break;

              case "NULL_OR_EMPTY_PRODUCT_PHOTO":
                Scaffold.of(context)
                    .showSnackBar(snackBar("Please select product photo(s)"));
                _loading = false;
                notifyListeners();
                break;

              case "PRODUCT_IMAGE_UPLOAD_FAIL":
                Scaffold.of(context).showSnackBar(
                    snackBar("Could not upload photos, please resubmit data"));
                _loading = false;
                notifyListeners();
                break;

              case "UPDATE_PRODUCT_DOCUMENT_WITH_PHOTO_FAIL":
                Scaffold.of(context).showSnackBar(
                    snackBar("Unexpected error after uploading photos"));
                _loading = false;
                notifyListeners();
                break;
              default:
                print(
                    "UNEXPECTED ERROR <<<<<<<<<<<<==================== $product ==================>>>>>>>>>>>");
                Scaffold.of(context).showSnackBar(
                    snackBar("An unknown error, please contact support"));
                _loading = false;
                notifyListeners();
            }
          } else {
            Scaffold.of(context).showSnackBar(snackBar(
                "product added successfully", Color.fromRGBO(67, 216, 201, 1)));
            _loading = false;
            notifyListeners();
          }
        }
      } else {
        Scaffold.of(context)
            .showSnackBar(snackBar("Please select photo(s) for your products"));
      }
    }
  }

  Future<void> selectProductPhotos(BuildContext context) async {
    try {
      _images = await FilePicker.getMultiFile(
        type: FileType.image,
      ).then((value) {
        if (value.length > 4) {
          Toast.show("Please select at most 4 photos", context,
              duration: 3, gravity: Toast.BOTTOM);
          value = value.sublist(0, 4);
        }
        print(value.length);
        return value;
      });
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
