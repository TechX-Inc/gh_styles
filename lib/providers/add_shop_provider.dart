import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gh_styles/services/shops_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddShopProvider with ChangeNotifier {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _logoUrl;

  final picker = ImagePicker();
  File _shopAvatar;
  bool _autovalidate = false;
  bool _loading = false;

  String _shopName;
  String _shopOwnerLegalName;
  String _shopPhoneContact;
  String _shopEmail;
  String _shopLocation;
  String _shopWebsite;
  String _uid;

  snackBar(message, [color = Colors.red]) => SnackBar(
        content: Text(message),
        backgroundColor: color,
      );

//GETTERS
  GlobalKey<FormState> get formKey => _formKey;
  File get image => _shopAvatar;
  bool get loading => _loading;
  bool get autovalidate => _autovalidate;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  String get logoUrl => _logoUrl;

//SETTERS
  set shopName(String shopName) {
    _shopName = shopName;
  }

  set ownerLegalName(String legalName) {
    _shopOwnerLegalName = legalName;
  }

  set phoneContact(String phoneContact) {
    _shopPhoneContact = phoneContact;
  }

  set email(String email) {
    _shopEmail = email;
  }

  set location(String location) {
    _shopLocation = location;
  }

  set websiteURL(String url) {
    _shopWebsite = url;
  }

  set removePhoto(File image) {
    _shopAvatar = image;
    notifyListeners();
  }

  set userID(String uid) {
    _uid = uid;
  }

  set setLogoUrl(String url) {
    if (url != null) {
      _logoUrl = url;
    }
    notifyListeners();
  }

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _shopAvatar = File(pickedFile.path);
    notifyListeners();
  }

  // ignore: missing_return
  Future<File> getImageFileFromAssets() async {
    final byteData = await rootBundle.load('assets/images/logo_default.jpg');
    final file =
        File('${(await getTemporaryDirectory()).path}/logo_default.jpg');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    if (await file.exists()) {
      return file;
    }
  }

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

      dynamic defaultLogo = await getImageFileFromAssets()
          .catchError((error) => print(error.message));

      Shop shop = new Shop(
        uid: _uid ?? null,
        shopName: _shopName.trim() ?? null,
        shopOwnerLegalName: _shopOwnerLegalName.trim() ?? null,
        shopContact: _shopPhoneContact.trim() ?? null,
        shopEmail: _shopEmail ?? null,
        shopLocation: _shopLocation ?? null,
        shopWebsite: _shopWebsite ?? "None",
        shopLogo: _shopAvatar ?? defaultLogo,
      );
      dynamic createShop = await shop.createShop();

      if (createShop != true) {
        switch (createShop.code) {
          case "FAILED_TO_CREATE_SHOP":
            Scaffold.of(context).showSnackBar(snackBar(createShop.message));
            _loading = false;
            notifyListeners();
            break;

          case "NULL_REQUIRED_FIELD":
            Scaffold.of(context).showSnackBar(snackBar(createShop.message));
            _loading = false;
            notifyListeners();
            break;

          case "UPDATE_SHOP_DOCUMENT_LOGO_FAIL":
            Scaffold.of(context).showSnackBar(snackBar(createShop.message));
            _loading = false;
            notifyListeners();
            break;

          case "SET_SHOP_OWNER_FALSE_FAILED":
            Scaffold.of(context).showSnackBar(snackBar(createShop.message));
            _loading = false;
            notifyListeners();
            break;

          case "SHOP_LOGO_UPLOAD_FAIL":
            Scaffold.of(context).showSnackBar(snackBar(createShop.message));
            _loading = false;
            notifyListeners();
            break;

          case "SET_SHOP_OWNER_FALSE_FAILED":
            Scaffold.of(context).showSnackBar(snackBar(createShop.message));
            _loading = false;
            notifyListeners();
            break;

          case "NULL_IMAGE_FILE":
            Scaffold.of(context).showSnackBar(snackBar(createShop.message));
            _loading = false;
            notifyListeners();
            break;
          default:
            print(
                "UNEXPECTED ERROR <<<<<<<<<<<<==================== $createShop ==================>>>>>>>>>>>");
            Scaffold.of(context).showSnackBar(
                snackBar("An unknown error, please contact support"));
            _loading = false;
            notifyListeners();
        }

        print(
            "ERROR <<<<<<<<<<============== $createShop ===============>>>>>>>>>>");
      } else {
        Scaffold.of(context).showSnackBar(snackBar(
            "New shop successfully registered as $_shopName",
            Color.fromRGBO(67, 216, 201, 1)));

        _loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> updateShop(BuildContext context, DocumentReference shopRef,
      String existingLogoPath) async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
      _loading = true;
      notifyListeners();

      dynamic defaultLogo = await getImageFileFromAssets()
          .catchError((error) => print(error.message));

      Shop shop = new Shop(
        shopName: _shopName.trim() ?? null,
        shopOwnerLegalName: _shopOwnerLegalName.trim() ?? null,
        shopContact: _shopPhoneContact.trim() ?? null,
        shopEmail: _shopEmail ?? null,
        shopLocation: _shopLocation ?? null,
        shopWebsite: _shopWebsite ?? "None",
        shopLogo: _shopAvatar ?? defaultLogo,
      );
      dynamic createShop = await shop.editShop(shopRef, existingLogoPath);

      if (createShop != true) {
        switch (createShop.code) {
          case "FAILED_TO_UPDATE_SHOP":
            Scaffold.of(context).showSnackBar(snackBar(createShop.message));
            _loading = false;
            notifyListeners();
            break;

          case "NULL_REQUIRED_FIELD":
            Scaffold.of(context).showSnackBar(snackBar(createShop.message));
            _loading = false;
            notifyListeners();
            break;

          // case "UPDATE_SHOP_DOCUMENT_LOGO_FAIL":
          //   Scaffold.of(context).showSnackBar(snackBar(createShop.message));
          //   _loading = false;
          //   notifyListeners();
          //   break;

          // case "SET_SHOP_OWNER_FALSE_FAILED":
          //   Scaffold.of(context).showSnackBar(snackBar(createShop.message));
          //   _loading = false;
          //   notifyListeners();
          //   break;

          // case "SHOP_LOGO_UPLOAD_FAIL":
          //   Scaffold.of(context).showSnackBar(snackBar(createShop.message));
          //   _loading = false;
          //   notifyListeners();
          //   break;

          // case "SET_SHOP_OWNER_FALSE_FAILED":
          //   Scaffold.of(context).showSnackBar(snackBar(createShop.message));
          //   _loading = false;
          //   notifyListeners();
          //   break;

          // case "NULL_IMAGE_FILE":
          //   Scaffold.of(context).showSnackBar(snackBar(createShop.message));
          //   _loading = false;
          //   notifyListeners();
          //   break;
          default:
            print(
                "UNEXPECTED ERROR <<<<<<<<<<<<==================== $createShop ==================>>>>>>>>>>>");
            Scaffold.of(context).showSnackBar(
                snackBar("An unknown error, please contact support"));
            _loading = false;
            notifyListeners();
        }
      } else if (createShop == true) {
        Scaffold.of(context).showSnackBar(
            snackBar("Changes saved", Color.fromRGBO(36, 161, 156, 1)));
        _loading = false;
        notifyListeners();
      } else {
        Scaffold.of(context).showSnackBar(
            snackBar("An unknown error occured while updating data"));
        _loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> removeLogo(String imageUrl, DocumentReference shopRef) async {
    // dynamic removeLogo = await new Shop().deleteLogoImage(photoUrl: imageUrl);
    // print(removeLogo);

    new Shop().deleteLogoImage(photoUrl: imageUrl).catchError((error) {
      _scaffoldKey.currentState
          .showSnackBar(snackBar("Failed to remove image"));
    }).then((value) {
      print(value);
      if (value == true) {
        shopRef.updateData({"shop_logo": null});
        _logoUrl = null;
        notifyListeners();
      } else {
        _scaffoldKey.currentState
            .showSnackBar(snackBar("Failed to remove image"));
      }
    });
  }
}
