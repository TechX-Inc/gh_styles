import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gh_styles/auth_and_validation/shop_validator.dart';
import 'package:gh_styles/models/shops_model.dart';
import 'package:gh_styles/models/users_auth_model.dart';
import 'package:gh_styles/providers/add_shop_provider.dart';
import 'package:provider/provider.dart';

class ShopForms extends StatefulWidget {
  final ShopsModel shopsModel;
  ShopForms({this.shopsModel});
  @override
  State<StatefulWidget> createState() => _ShopFormsWidgetState();
}

class _ShopFormsWidgetState extends State<ShopForms> {
  AddShopProvider _addShopFormHandler;

  @override
  void initState() {
    super.initState();
    _addShopFormHandler = Provider.of<AddShopProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    String uid = user?.uid;
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
      initialValue:
          widget.shopsModel != null ? widget.shopsModel.shopName : null,
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
      initialValue: widget.shopsModel != null
          ? widget.shopsModel.shopOwnerLegalName
          : null,
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
      initialValue:
          widget.shopsModel != null ? widget.shopsModel.shopEmail : null,
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
      initialValue:
          widget.shopsModel != null ? widget.shopsModel.shopContact : null,
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
      initialValue:
          widget.shopsModel != null ? widget.shopsModel.shopLocation : null,
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
      initialValue:
          widget.shopsModel != null ? widget.shopsModel.shopWebsite : null,
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
              onPressed: () => widget.shopsModel == null
                  ? _addShopFormHandler.processAndSave(context)
                  : _addShopFormHandler.updateShop(),
            )
          : SpinKitWave(
              color: Color.fromRGBO(109, 0, 39, 1),
              size: 20.0,
            );
    });
  }
}
