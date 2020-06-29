import 'dart:async';
import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
import 'package:gh_styles/models/users.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/authentication/shop_validator.dart';
import 'package:provider/provider.dart';
import 'package:gh_styles/models/shops.dart';
// import 'package:gh_styles/utils/business_logo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final key = new GlobalKey<_ShopLogoState>();

class AddShop extends StatefulWidget {
  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  File logo = key.currentState.image;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: Color.fromRGBO(109, 0, 39, 1),
      // color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: Container(
                          // width: 200,
                          // color: Colors.green,
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ShopLogo(key: key),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Add Logo",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      )),
                    ),
                    Expanded(
                      child: Container(
                        // transform: Matrix4.translationValues(0, 50, 1),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        child: ShopForms(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ShopForms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShopFormsWidgetState();
}

/*
<<<<<<<<<<<<<<<<<<========================== ADD SHOP FORMS =================================>>>>>>>>>>>>>>>>>>>
 */
class _ShopFormsWidgetState extends State<ShopForms> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _shopName;
  String _shopOwnerLegalName;
  String _shopPhone;
  String _shopEmail;
  String _shopLocation;
  String _shopWebsite;
  String uid;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    uid = user.uid;

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
              child: Column(
                children: <Widget>[
                  _shopNameField(),
                  _ownerLegalNameField(),
                  _shopEmailField(),
                  _shopPhoneField(),
                  _shopLocationField(),
                  _websiteUrlField(),
                  SizedBox(height: 40),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shopNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Shop Name *",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(109, 0, 39, 1)),
        ),
      ),
      validator: (value) => ValidateShopData.checkRequired(value.trim()),
      onSaved: (newValue) => _shopName = newValue,
    );
  }

  Widget _ownerLegalNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Owner Legal Name *",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(109, 0, 39, 1)),
        ),
      ),
      validator: (value) => ValidateShopData.checkRequired(value),
      onSaved: (newValue) => _shopOwnerLegalName = newValue,
    );
  }

  Widget _shopEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email *",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(109, 0, 39, 1)),
        ),
      ),
      validator: (value) => ValidateShopData.validateEmail(value.trim()),
      onSaved: (newValue) => _shopEmail = newValue,
    );
  }

  Widget _shopPhoneField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Phone Number *",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(109, 0, 39, 1)),
        ),
      ),
      validator: (value) => ValidateShopData.validateNumber(value),
      onSaved: (newValue) => _shopPhone = newValue,
    );
  }

  Widget _shopLocationField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Location *",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(109, 0, 39, 1)),
        ),
      ),
      validator: (value) => ValidateShopData.checkRequired(value),
      onSaved: (newValue) => _shopLocation = newValue,
    );
  }

  Widget _websiteUrlField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Website URL",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(109, 0, 39, 1)),
        ),
      ),
      validator: (value) => ValidateShopData.validateUrl(value.trim()),
      onSaved: (newValue) => _shopWebsite = newValue,
    );
  }

  Widget _buildSubmitButton() {
    return !loading
        ? RaisedButton(
            color: Color.fromRGBO(109, 0, 39, 1),
            child: Text(
              'Create Shop',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => _processAndSave(context),
          )
        : SpinKitWave(
            color: Color.fromRGBO(109, 0, 39, 1),
            size: 20.0,
          );
  }

  final snackBar = SnackBar(
    content: Text('Operation failed. please try again'),
    backgroundColor: Colors.red,
  );

  Future<void> _processAndSave(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();

      setState(() {
        loading = true;
      });
      File logo = key.currentState.image;
      Shop shop = new Shop(
        uid: uid != null ? uid : null,
        shopName: _shopName != null ? _shopName : null,
        shopOwnerLegalName:
            _shopOwnerLegalName != null ? _shopOwnerLegalName : "hello",
        shopContact: _shopPhone != null ? _shopPhone : null,
        shopEmail: _shopEmail != null ? _shopEmail : null,
        shopLocation: _shopLocation != null ? _shopLocation : null,
        shopWebsite: _shopWebsite != "" ? _shopWebsite : "None",
        shopLogo: logo != null ? logo : "None",
      );
      dynamic createShop = await shop.createShop();
      if (createShop == null) {
        setState(() {
          loading = false;
        });
        print(
            "ERROR <<<<<<<<<<============== $createShop ===============>>>>>>>>>>");
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        setState(() {
          loading = false;
        });
      }
    }
  }
}

class ShopLogo extends StatefulWidget {
  ShopLogo({Key key}) : super(key: key);
  @override
  _ShopLogoState createState() => _ShopLogoState();
}

class _ShopLogoState extends State<ShopLogo> {
  final picker = ImagePicker();
  File _image;
  File get image => _image;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        width: 65.0,
        height: 65.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: IconButton(
            icon: Icon(
              Icons.add_a_photo,
              color: Color.fromRGBO(109, 0, 39, 1),
              size: 30.0,
            ),
            onPressed: getImage));
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
  }
}
