import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gh_styles/auth_and_validation/shop_validator.dart';
import 'package:gh_styles/models/shops_model.dart';
import 'package:gh_styles/models/users_auth_model.dart';
import 'package:gh_styles/providers/shop_management_provider.dart';
import 'package:provider/provider.dart';

class ShopForms extends StatefulWidget {
  final ShopsModel shopsModel;
  ShopForms({this.shopsModel});
  @override
  State<StatefulWidget> createState() => _ShopFormsWidgetState();
}

class _ShopFormsWidgetState extends State<ShopForms> {
  AddShopProvider _addShopFormProvider;
  User user;

  @override
  void initState() {
    super.initState();
    _addShopFormProvider = Provider.of<AddShopProvider>(context, listen: false);
    user = Provider.of<User>(context, listen: false);
    _addShopFormProvider.userID = user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shopsModel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          _addShopFormProvider.setLogoUrl = widget.shopsModel.shopLogoPath);
    }

    return Form(
      key: _addShopFormProvider.formKey,
      autovalidate: _addShopFormProvider.autovalidate,
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<AddShopProvider>(builder: (context, data, _) {
              if (data.logoUrl != null && data.image == null) {
                return Column(
                  children: [
                    CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(widget.shopsModel.shopLogoPath)),
                    SizedBox(height: 5),
                    FlatButton(
                        onPressed: () => data.removeLogo(
                            widget.shopsModel.shopLogoPath,
                            widget.shopsModel.shopRef),
                        child: Text(
                          "Remove",
                          style: TextStyle(color: Colors.redAccent),
                        ))
                  ],
                );
              } else {
                return data.image != null
                    ? Column(
                        children: [
                          Container(
                            child: CircleAvatar(
                                radius: 30,
                                backgroundImage: FileImage(data.image)),
                          ),
                          SizedBox(height: 5),
                          FlatButton(
                              onPressed: () => data.removePhoto = null,
                              child: Text(
                                "Remove",
                                style: TextStyle(color: Colors.redAccent),
                              ))
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage("assets/images/dummy_logo.png"),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Business Logo")
                        ],
                      );
              }
            }),
            widget.shopsModel != null
                ? Expanded(
                    child: Container(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.edit,
                          size: 40,
                          color: Colors.blueAccent,
                        )),
                  )
                : Text(
                    "Register Business",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  )
          ],
        ),
        SizedBox(
          height: 30,
        ),
        _shopNameField(),
        SizedBox(
          height: 15,
        ),
        _ownerLegalNameField(),
        SizedBox(
          height: 15,
        ),
        _shopEmailField(),
        SizedBox(
          height: 15,
        ),
        _shopPhoneField(),
        SizedBox(
          height: 15,
        ),
        _shopLocationField(),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(child: _websiteUrlField()),
            SizedBox(
              width: 30,
            ),
            IconButton(
                onPressed: () =>
                    _addShopFormProvider.pickImage(context: context),
                icon: Icon(
                  Icons.camera_enhance,
                  size: 30,
                ))
          ],
        ),
        SizedBox(height: 40),
        _buildSubmitButton()
      ]),
    );
  }

  Widget _shopNameField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Shop Name ',
        // labelText: "Shop Name *",
        hintStyle: TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        // fillColor: colorSearchBg,
      ),
      validator: (value) => ValidateShopData.checkRequired(value.trim()),
      onSaved: (sName) => _addShopFormProvider.shopName = sName,
      initialValue:
          widget.shopsModel != null ? widget.shopsModel.shopName : null,
    );
  }

  Widget _ownerLegalNameField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Owner Legal Name ',
        // labelText: "Owner Legal Name *",
        hintStyle: TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        // fillColor: colorSearchBg,
      ),
      validator: (value) => ValidateShopData.checkRequired(value),
      onSaved: (ownerLegalName) =>
          _addShopFormProvider.ownerLegalName = ownerLegalName,
      initialValue: widget.shopsModel != null
          ? widget.shopsModel.shopOwnerLegalName
          : null,
    );
  }

  Widget _shopEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Email ',
        // labelText: "Email *",
        hintStyle: TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        // fillColor: colorSearchBg,
      ),
      validator: (value) => ValidateShopData.validateEmail(value.trim()),
      onSaved: (email) => _addShopFormProvider.email = email,
      initialValue:
          widget.shopsModel != null ? widget.shopsModel.shopEmail : null,
    );
  }

  Widget _shopPhoneField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Phone Number ',
        // labelText: "Phone Number *",
        hintStyle: TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        // fillColor: colorSearchBg,
      ),
      validator: (value) => ValidateShopData.validateNumber(value),
      onSaved: (phone) => _addShopFormProvider.phoneContact = phone,
      initialValue:
          widget.shopsModel != null ? widget.shopsModel.shopContact : null,
    );
  }

  Widget _shopLocationField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Location',
        // labelText: "Location *",
        hintStyle: TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        // fillColor: colorSearchBg,
      ),
      validator: (value) => ValidateShopData.checkRequired(value),
      onSaved: (location) => _addShopFormProvider.location = location,
      initialValue:
          widget.shopsModel != null ? widget.shopsModel.shopLocation : null,
    );
  }

  Widget _websiteUrlField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Website URL ',
        // labelText: "Website URL *",
        hintStyle: TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        // fillColor: colorSearchBg,
      ),
      validator: (value) => ValidateShopData.validateUrl(value.trim()),
      onSaved: (url) => _addShopFormProvider.websiteURL = url,
      initialValue:
          widget.shopsModel != null ? widget.shopsModel.shopWebsite : null,
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<AddShopProvider>(builder: (context, data, _) {
      return !data.loading
          ? SizedBox(
              width: double.infinity,
              height: 60,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                // color: Color.fromRGBO(109, 0, 39, 1),
                color: Color.fromRGBO(85, 179, 223, 1),
                child: Text(
                  widget.shopsModel != null ? "Save Changes" : 'Create Shop',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => widget.shopsModel == null
                    ? _addShopFormProvider.processAndSave(context)
                    : _addShopFormProvider.updateShop(
                        context,
                        widget.shopsModel.shopRef,
                        widget.shopsModel.shopLogoPath),
              ),
            )
          : SpinKitFadingCircle(
              color: Color.fromRGBO(85, 179, 223, 1),
              size: 50.0,
            );
    });
  }
}
