import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gh_styles/authentication/validation_signup.dart';
import 'package:gh_styles/providers/add_product_provider.dart';
import 'package:gh_styles/providers/register_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:provider/provider.dart';

class NewProductForm extends StatefulWidget {
  @override
  _NewProductFormState createState() => _NewProductFormState();
}

class _NewProductFormState extends State<NewProductForm> {
  AddProductProvider _addProduct;
  String _productCollectionRadio = "Kids";
  String _categorySelectValue = "Footwears";
  String _genderSelectValue = "Male";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addProduct = Provider.of<AddProductProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addProduct.formKey,
      autovalidate: _addProduct.autovalidate,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 40),
              child: Image.asset("assets/images/gh_style.png",
                  height: 70, width: 70),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Shop Name",
                        style: GoogleFonts.cinzel(
                            textStyle: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 20)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _productName(),
                  _productQuantity(),
                  _productDescription(),
                  Row(
                    children: <Widget>[
                      Expanded(child: _productPrice()),
                      SizedBox(width: 30),
                      Expanded(child: _productDiscount()),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: _productCategory()),
                      SizedBox(width: 30),
                      Expanded(child: _gender()),
                    ],
                  ),
                  _collection(),
                  SizedBox(
                    height: 35,
                  ),
                  _signInBtn(),
                ],
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                      text: 'Need help?',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Contact Support',
                            style: TextStyle(color: Colors.red, fontSize: 15),
                            recognizer: TapGestureRecognizer()..onTap = () {})
                      ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _productName() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(hintText: "Product Name"),
      // validator: (value) => ValidateSignUp.validateUsername(value.trim()),
      // onSaved: (username) => _registerHandler.setUsename = username,
    );
  }

  Widget _productPrice() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: "Price"),
      // validator: (value) => ValidateSignUp.validateEmail(value.trim()),
      // onSaved: (email) => _registerHandler.setEmail = email,
    );
  }

  Widget _productDiscount() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: "Discount(%)"),
      // validator: (value) => ValidateSignUp.validateEmail(value.trim()),
      // onSaved: (email) => _registerHandler.setEmail = email,
    );
  }

  Widget _productQuantity() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: "Quantity"),
      // validator: (value) => ValidateSignUp.validateEmail(value.trim()),
      // onSaved: (email) => _registerHandler.setEmail = email,
    );
  }

  Widget _productDescription() {
    return TextFormField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(hintText: "Description"),
      // validator: (value) => ValidateSignUp.validateEmail(value.trim()),
      // onSaved: (email) => _registerHandler.setEmail = email,
    );
  }

  Widget _productCategory() {
    return DropdownButton<String>(
      value: _categorySelectValue,
      onChanged: (String newValue) {
        setState(() {
          _categorySelectValue = newValue;
        });
      },
      items: <String>[
        _categorySelectValue,
        'Shoes',
        'Bags',
        'Clothings',
        'Shirts',
        'Shorts'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _gender() {
    return DropdownButton<String>(
      value: _genderSelectValue,
      onChanged: (String newValue) {
        setState(() {
          _genderSelectValue = newValue;
        });
      },
      items: <String>[_genderSelectValue, "Female"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _collection() {
    return RadioButtonGroup(
        picked: _productCollectionRadio,
        orientation: GroupedButtonsOrientation.HORIZONTAL,
        padding: EdgeInsets.all(0),
        labels: <String>[
          "Kids",
          "Adults",
        ],
        onSelected: (String selected) {
          setState(() {
            _productCollectionRadio = selected;
          });
        });
  }

  Widget _signInBtn() {
    return RaisedButton(
      color: Color.fromRGBO(181, 7, 107, 1),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(child: Consumer<AddProductProvider>(
          builder: (context, data, _) {
            return !data.loading
                ? Text(
                    "Save",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )
                : SpinKitThreeBounce(
                    color: Colors.white,
                    size: 25.0,
                  );
          },
        )),
      ),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      onPressed: () {},
    );
  }
}
/*
Product Name
Product Price
Product Discount(in %)
Product Photos

===============================================
Type         gender      Collection

Shoes        Male         Kids
Bags         Female       Adults
Clothings
Shirts
Shorts




 */
