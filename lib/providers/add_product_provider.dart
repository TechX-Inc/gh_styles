import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gh_styles/auth_and_validation/auth_service.dart';
import 'package:gh_styles/models/users.dart';
import 'package:gh_styles/services/products.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AddProductProvider with ChangeNotifier {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = new AuthService();
  List<Asset> _images = List<Asset>();
  bool _autovalidate = false;
  bool _loading = false;

  CollectionReference user = Firestore.instance.collection("Users");
  CollectionReference shop = Firestore.instance.collection("Shops");

  String _uid;

  String _productName;
  String _productQuantity;
  String _productDescription;
  String _productPrice;
  String _productDiscount;
  String _productType = 'Foot Wears';
  String _gender = 'Male';
  String _productSize;
  String _collection = 'Kids';

//GETTERS
  GlobalKey<FormState> get formKey => _formKey;
  AuthService get auth => _auth;
  bool get loading => _loading;
  bool get autovalidate => _autovalidate;
  List<Asset> get images => _images;

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

  set setproductDescription(String productDescription) {
    _productDescription = productDescription;
  }

  set setproductType(String productType) {
    _productType = productType;
  }

  set setgender(String gender) {
    _gender = gender;
  }

  set setproductSize(String productSize) {
    _productSize = productSize;
  }

  set setcollection(String collection) {
    _collection = collection;
  }

  set setUID(String uid) {
    _uid = uid;
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

  Widget snackBar(error) => SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      );

  Future<void> processAndSave(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      _autovalidate = true;
      _formKey.currentState.build(context);
      notifyListeners();
      return;
    } else {
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
        ProductService newProduct = new ProductService(
            shopRef: shopRef,
            productName: _productName ?? null,
            productQuantity: _productQuantity ?? 1.toString(),
            productDescription: _productDescription ?? '',
            productDiscount: _productDiscount ?? 0.toString(),
            productPrice: _productPrice ?? null,
            productType: _productType,
            productSize: _productSize ?? null,
            gender: _gender,
            collection: _collection);
        dynamic product = await newProduct.newProduct();
        switch (product) {
          case "NULL_IN_REQUIRE_VALUES":
            Scaffold.of(context).showSnackBar(
                snackBar("Error, provide all required(*) fields"));
            _loading = false;
            notifyListeners();
            break;

          case "PRODUCT_ADD_FAILED":
            Scaffold.of(context)
                .showSnackBar(snackBar("Unexpected error occured, try again"));
            _loading = false;
            notifyListeners();
            break;
          default:
            print(
                "UNEXPECTED ERROR <<<<<<<<<<<<==================== $product ==================>>>>>>>>>>>");
            Scaffold.of(context).showSnackBar(
                snackBar("Something went wrong, please try again"));
            _loading = false;
            notifyListeners();
        }
      }
    }
  }

  Future<void> uploadProductPhotos() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          // actionBarColor: "#abcdef",
          actionBarTitle: "Choose photos",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {}
    _images = resultList;
    notifyListeners();
  }
}
