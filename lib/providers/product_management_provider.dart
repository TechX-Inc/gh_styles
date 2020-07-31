import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  List<dynamic> _existingImages = List();
  bool _loading = false;
  DocumentReference _userShopReference;

//SNACKBAR FOR ERROR AND SUCCESS MESSAGES
  Widget snackBar(error, [color = Colors.red]) => SnackBar(
        content: Text(error),
        backgroundColor: color,
      );

// PRODUCT FORM FIELDS
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
  List<dynamic> get existingImages => _existingImages;
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

// SETS USER SHOP REFERENCE TO SEND TO DATABASE
  set setUserShopReference(DocumentReference shopRef) {
    if (shopRef != null) {
      _userShopReference = shopRef;
    }
    notifyListeners();
  }

// REMOVE SELECTED IMAGE
  set imageToRemoveIndex(int index) {
    _images.removeAt(index);
  }

  set setExistingImage(List<dynamic> existingImages) {
    if (existingImages != null) {
      _existingImages = existingImages;
    }
    notifyListeners();
  }

// WHEN FORM IS IN EDITING MODE, THIS COMPUTES THE POSITION THE EXISTING PRODUCT IMAGE AND NEWLY ADDED PRODUCT IMAGE SHOULD BE POSITIONED
  int computeExistingImageWidth() {
    int computedCount;
    if (_images.isEmpty && _existingImages.length <= 1) {
      computedCount = 2;
    } else {
      computedCount = _existingImages.length;
    }
    return computedCount;
  }

// HANDLES PRODUCT FILE UPLOADS
  Future<void> selectProductPhotos(BuildContext context) async {
    try {
      _images = await FilePicker.getMultiFile(
        type: FileType.image,
      ).then((value) {
        if ((value.length + _existingImages.length) > 4) {
          Toast.show(
              _existingImages.length <= 0
                  ? "Please select at most 4 photos"
                  : "You have only ${value.length - _existingImages.length} additional photo(s) remaining",
              context,
              duration: 3,
              gravity: Toast.BOTTOM);
          value = value.sublist(0, (4 - _existingImages.length));
        }
        return value;
      });
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
  }

  // ADDS A NEW PRODUCT TO THE DATABASE
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
          productDiscount:
              (_productDiscount == null) ? 0.toDouble() : _productDiscount,
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

  //UPDATE PRODUCT
  Future<void> updateProduct(DocumentReference productReference,
      List<dynamic> productCurrentImages) async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
      _loading = true;
      notifyListeners();

      if (_existingImages.isEmpty && _images.isEmpty) {
        _scaffoldKey.currentState
            .showSnackBar(snackBar("Please select product photo(s)"));
        _loading = false;
        notifyListeners();
      } else {
        ProductService productChanges = new ProductService(
            productPhotos: _images,
            productName: (_productName == null || _productName == "")
                ? null
                : _productName.trim(),
            productQuantity: _productQuantity == null ? 1 : _productQuantity,
            productDescription: _productDescription ?? '',
            productDiscount: (_productDiscount == null) ? 0 : _productDiscount,
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

  /// REMOVE PRODUCT PHOTO IN EDIT MODE(DELETES THE IMAGE FROM FIREBASE STORAGE)
  Future<void> removeProductPhoto(
      String downloadUrl, DocumentReference productReference, int index) async {
    new ProductService()
        .deleteProductPhoto(photoUrl: downloadUrl)
        .catchError((error) {
      _scaffoldKey.currentState
          .showSnackBar(snackBar("Failed to remove image"));
    }).then((value) {
      if (value == true) {
        Firestore.instance.runTransaction((Transaction tx) async {
          DocumentSnapshot productSnapshot = await tx.get(productReference);
          if (productSnapshot.exists) {
            await tx.update(productReference, {
              'product_photos': FieldValue.arrayRemove([downloadUrl])
            }).then((value) {
              _existingImages.removeAt(index);
              notifyListeners();
            });
          }
        });
      } else {
        switch (value.code) {
          case "IMAGE_NOT_FOUND":
            print("404 image not found");
            Firestore.instance.runTransaction((Transaction tx) async {
              DocumentSnapshot productSnapshot = await tx.get(productReference);
              if (productSnapshot.exists) {
                await tx.update(productReference, {
                  'product_photos': FieldValue.arrayRemove([downloadUrl])
                }).then((value) {
                  _existingImages.removeAt(index);
                  notifyListeners();
                });
              }
            });
            break;

          case "UNABLE_TO_DELETE_PHOTO":
            print(value.code);
            _scaffoldKey.currentState.showSnackBar(snackBar(value.message));
            _loading = false;
            notifyListeners();
            break;
          default:
            print("DEFAULT <<<<<<<<<<<<========== $value =========>>>>>>>>>>>");
            _scaffoldKey.currentState
                .showSnackBar(snackBar("An unknown error"));
            _loading = false;
            notifyListeners();
        }
      }
    });
  }
}
