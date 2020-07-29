import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/auth_and_validation/auth_service.dart';
import 'package:gh_styles/services/products_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:toast/toast.dart';

class AddProductProvider with ChangeNotifier {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStepperOne = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final AuthService _auth = new AuthService();
  List<File> _images = List();
  bool _loading = false;
  int _existingImageLength = 0;
  DocumentReference _userShopReference;

  Widget snackBar(error, [color = Colors.red]) => SnackBar(
        content: Text(error),
        backgroundColor: color,
      );

  CollectionReference user = Firestore.instance.collection("Users");
  CollectionReference shop = Firestore.instance.collection("Shops");

  // String _uid;

  String _productName;
  int _productQuantity;
  String _productDescription;
  double _productPrice;
  double _productDiscount;
  String _productType = 'Footwears';
  String _gender = 'Male';
  String _productSize;
  String _collection = 'Kids';

//GETTERS
  GlobalKey<FormState> get formKey => _formKey;
  GlobalKey<FormState> get formKeyStepperOne => _formKeyStepperOne;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

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

  set setproductQuantity(int productQuantity) {
    _productQuantity = productQuantity;
  }

  set setproductPrice(double productPrice) {
    _productPrice = productPrice;
  }

  set setproductDiscount(double productDiscount) {
    _productDiscount = productDiscount;
  }

  set setproductDescription(String productDescription) {
    _productDescription = productDescription;
  }

  set setproductType(String productType) {
    if (productType != null) {
      _productType = productType;
    }
    notifyListeners();
  }

  set setgender(String gender) {
    if (gender != null) {
      _gender = gender;
    }
    notifyListeners();
  }

  set setproductSize(String productSize) {
    _productSize = productSize;
  }

  set setcollection(String collection) {
    if (collection != null) {
      _collection = collection;
    }
    notifyListeners();
  }

  set setExistingImageLength(int length) {
    _existingImageLength = length;
  }

  // set setUID(String uid) {
  //   _uid = uid;
  // }

  set imageToRemoveIndex(int index) {
    _images.removeAt(index);
  }

  set setUserShopReference(DocumentReference shopRef) {
    if (shopRef != null) {
      _userShopReference = shopRef;
    }
    notifyListeners();
  }

  Future<void> processAndSave() async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
      _loading = true;
      notifyListeners();

      ProductService newProduct = new ProductService(
          shopRef: _userShopReference,
          productPhotos: _images.isNotEmpty ? _images : null,
          productName: (_productName == null || _productName == "")
              ? null
              : _productName.trim(),
          productQuantity: _productQuantity == null ? 1 : _productQuantity,
          productDescription: _productDescription ?? '',
          productDiscount: (_productDiscount == null) ? null : _productDiscount,
          productPrice: (_productPrice == null) ? null : _productPrice,
          productType: _productType.trim(),
          productSize: (_productSize == null) ? null : _productSize,
          gender: _gender.trim(),
          collection: _collection.trim());
      dynamic product = await newProduct.newProduct();

      if (product != true) {
        switch (product.code) {
          case "NULL_IN_REQUIRED_FIELD":
            print(product.code);
            _scaffoldKey.currentState.showSnackBar(snackBar(product.message));
            _loading = false;
            notifyListeners();
            break;

          case "PRODUCT_ADD_FAILED":
            print(product.code);
            _scaffoldKey.currentState.showSnackBar(snackBar(product.message));
            _loading = false;
            notifyListeners();
            break;

          case "NO_IMAGE_FILE_FOUND":
            print(product.code);
            _scaffoldKey.currentState.showSnackBar(snackBar(product.message));
            _loading = false;
            notifyListeners();
            break;

          case "GET_DOWNLOAD_URL_FAILED":
            print(product.code);
            _scaffoldKey.currentState.showSnackBar(snackBar(product.message));
            _loading = false;
            notifyListeners();
            break;

          case "UPDATE_PRODUCT_DOCUMENT_WITH_PHOTO_FAIL":
            print(product.code);
            _scaffoldKey.currentState.showSnackBar(snackBar(product.message));
            _loading = false;
            notifyListeners();
            break;
          default:
            print(
                "DEFAULT <<<<<<<<<<<<==================== $product ==================>>>>>>>>>>>");
            _scaffoldKey.currentState.showSnackBar(
                snackBar("An unknown error, please contact support"));
            _loading = false;
            notifyListeners();
        }
      } else {
        _scaffoldKey.currentState.showSnackBar(snackBar(
            "product added successfully", Color.fromRGBO(36, 161, 156, 1)));
        _loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> selectProductPhotos(BuildContext context) async {
    try {
      _images = await FilePicker.getMultiFile(
        type: FileType.image,
      ).then((value) {
        if ((value.length + _existingImageLength) > 4) {
          Toast.show(
              _existingImageLength <= 0
                  ? "Please select at most 4 photos"
                  : "You have only ${value.length - _existingImageLength} additional photos remaining",
              context,
              duration: 3,
              gravity: Toast.BOTTOM);
          value = value.sublist(0, (4 - _existingImageLength));
        }
        print(value.length);
        return value;
      });
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> updateProduct(DocumentReference productReference,
      List<dynamic> productCurrentImages) async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
      _loading = true;
      notifyListeners();

      ProductService productChanges = new ProductService(
          productPhotos: _images,
          productName: (_productName == null || _productName == "")
              ? null
              : _productName.trim(),
          productQuantity: _productQuantity == null ? 1 : _productQuantity,
          productDescription: _productDescription ?? '',
          productDiscount: (_productDiscount == null) ? null : _productDiscount,
          productPrice: (_productPrice == null) ? null : _productPrice,
          productType: _productType.trim(),
          productSize: (_productSize == null) ? null : _productSize,
          gender: _gender.trim(),
          collection: _collection.trim());
      dynamic product = await productChanges.editProduct(
          productReference, productCurrentImages);

      if (product != true) {
        switch (product.code) {
          case "NULL_IN_REQUIRED_FIELD":
            print(product.code);
            _scaffoldKey.currentState.showSnackBar(snackBar(product.message));
            _loading = false;
            notifyListeners();
            break;

          case "PRODUCT_UPDATE_FAILED":
            print(product.code);
            _scaffoldKey.currentState.showSnackBar(snackBar(product.message));
            _loading = false;
            notifyListeners();
            break;

          // case "NO_IMAGE_FILE_FOUND":
          //   print(product.code);
          //   _scaffoldKey.currentState.showSnackBar(snackBar(product.message));
          //   _loading = false;
          //   notifyListeners();
          //   break;

          // case "GET_DOWNLOAD_URL_FAILED":
          //   print(product.code);
          //   _scaffoldKey.currentState.showSnackBar(snackBar(product.message));
          //   _loading = false;
          //   notifyListeners();
          //   break;

          // case "UPDATE_PRODUCT_DOCUMENT_WITH_PHOTO_FAIL":
          //   print(product.code);
          //   _scaffoldKey.currentState.showSnackBar(snackBar(product.message));
          //   _loading = false;
          //   notifyListeners();
          //   break;
          default:
            print(
                "DEFAULT <<<<<<<<<<<<==================== $product ==================>>>>>>>>>>>");
            _scaffoldKey.currentState.showSnackBar(
                snackBar("An unknown error, please contact support"));
            _loading = false;
            notifyListeners();
        }
      } else if (product == true) {
        _scaffoldKey.currentState.showSnackBar(
            snackBar("Changes saved", Color.fromRGBO(36, 161, 156, 1)));
        _loading = false;
        notifyListeners();
      } else {
        _scaffoldKey.currentState
            .showSnackBar(snackBar("An unknown error occured"));
        _loading = false;
        notifyListeners();
      }
    }
  }
}
