import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/authentication/shop_validator.dart';

class AddShop extends StatefulWidget {
  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              color: Color.fromRGBO(109, 0, 39, 1),
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AppLogo(),
                    Expanded(
                      child: Text(
                        "Business",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    )
                  ],
                )),
            Positioned(top: 140, left: 10, right: 10, child: NewShopForms())
          ],
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: Icon(
        Icons.business,
        color: Color.fromRGBO(109, 0, 39, 1),
        size: 30.0,
      ),
    );
  }
}

class NewShopForms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewShopFormsWidgetState();
}

class _NewShopFormsWidgetState extends State<NewShopForms> {
  String _shopName;
  String _shopOwnerLegalName;
  String _shopPhone;
  String _shopEmail;
  String _shopLocation;
  String _shopWebsite;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode = new FocusNode();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Card(
            elevation: 0,
            shadowColor: Colors.white,
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
      onSaved: (newValue) => newValue = _shopName,
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
      onSaved: (newValue) => newValue = _shopOwnerLegalName,
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
      onSaved: (newValue) => newValue = _shopEmail,
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
      onSaved: (newValue) => newValue = _shopPhone,
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
      onSaved: (newValue) => newValue = _shopLocation,
    );
  }

  Widget _websiteUrlField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Website",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(109, 0, 39, 1)),
        ),
      ),
      validator: (value) => ValidateShopData.validateUrl(value.trim()),
      onSaved: (newValue) => newValue = _shopWebsite,
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      color: Color.fromRGBO(109, 0, 39, 1),
      child: Text(
        'Create Shop',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: _processAndSave,
    );
  }

  void _processAndSave() {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
      print("Valid data");
    }
  }
}
