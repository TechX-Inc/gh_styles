import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gh_styles/authentication/shop_validator.dart';
import 'package:gh_styles/models/users.dart';
import 'package:gh_styles/providers/add_shop_provider.dart';
import 'package:provider/provider.dart';

class ShopForms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShopFormsWidgetState();
}

class _ShopFormsWidgetState extends State<ShopForms> {
  AddShopProvider _addShopFormHandler;

  @override
  Widget build(BuildContext context) {
    _addShopFormHandler = Provider.of<AddShopProvider>(context, listen: false);

    final user = Provider.of<User>(context);
    String uid = user.uid;
    _addShopFormHandler.userID = uid;

    return Form(
      key: _addShopFormHandler.formKey,
      autovalidate: _addShopFormHandler.autovalidate,
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
      onSaved: (sName) => _addShopFormHandler.shopName = sName,
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
      onSaved: (ownerLegalName) =>
          _addShopFormHandler.ownerLegalName = ownerLegalName,
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
      onSaved: (email) => _addShopFormHandler.email = email,
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
      onSaved: (phone) => _addShopFormHandler.phoneContact = phone,
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
      onSaved: (location) => _addShopFormHandler.location = location,
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
      onSaved: (url) => _addShopFormHandler.websiteURL = url,
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<AddShopProvider>(builder: (context, data, _) {
      return !data.loading
          ? RaisedButton(
              color: Color.fromRGBO(109, 0, 39, 1),
              child: Text(
                'Create Shop',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => _addShopFormHandler.processAndSave(context),
            )
          : SpinKitWave(
              color: Color.fromRGBO(109, 0, 39, 1),
              size: 20.0,
            );
    });
  }
}
