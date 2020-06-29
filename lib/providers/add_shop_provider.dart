import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/models/shops.dart';
import 'package:image_picker/image_picker.dart';

class AddShopProvider with ChangeNotifier {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File _shopAvatar;
  bool _autovalidate = false;

  String _shopName;
  String _shopOwnerLegalName;
  String _shopPhoneContact;
  String _shopEmail;
  String _shopLocation;
  String _shopWebsite;
  String _uid;
  bool _loading = false;

//GETTERS
  GlobalKey<FormState> get formKey => _formKey;
  File get image => _shopAvatar;
  bool get loading => _loading;
  bool get autovalidate => _autovalidate;

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

  set userID(String uid) {
    _uid = uid;
  }

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _shopAvatar = File(pickedFile.path);
    // print("<<<<<<<================ $_shopAvatar ===============>>>>>>>");
    notifyListeners();
  }

  final snackBar = SnackBar(
    content: Text('Operation failed. please try again'),
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

      Shop shop = new Shop(
        uid: _uid != null ? _uid : null,
        shopName: _shopName != null ? _shopName : null,
        shopOwnerLegalName:
            _shopOwnerLegalName != null ? _shopOwnerLegalName : null,
        shopContact: _shopPhoneContact != null ? _shopPhoneContact : null,
        shopEmail: _shopEmail != null ? _shopEmail : null,
        shopLocation: _shopLocation != null ? _shopLocation : null,
        shopWebsite: _shopWebsite != "" ? _shopWebsite : "None",
        shopLogo: _shopAvatar,
      );
      dynamic createShop = await shop.createShop();

      if (createShop == null) {
        _loading = false;
        notifyListeners();
        Scaffold.of(context).showSnackBar(snackBar);
        print(
            "ERROR <<<<<<<<<<============== $createShop ===============>>>>>>>>>>");
      } else {
        _loading = false;
        notifyListeners();
      }
    }
    notifyListeners();
  }
}
