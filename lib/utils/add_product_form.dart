import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gh_styles/auth_and_validation/validation_product.dart';
import 'package:gh_styles/models/users.dart';
import 'package:gh_styles/providers/add_product_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:provider/provider.dart';

class NewProductForm extends StatefulWidget {
  @override
  _NewProductFormState createState() => _NewProductFormState();
}

class _NewProductFormState extends State<NewProductForm> {
  AddProductProvider _addProduct;
  int _currentStep = 0;
  User _user;
  DocumentReference shopRef;
  String shopName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = Provider.of<User>(context, listen: false);
    _addProduct = Provider.of<AddProductProvider>(context, listen: false);
    _addProduct.setUID = _user.uid;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addProduct.formKey,
      autovalidate: _addProduct.autovalidate,
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 30),
                child: FutureBuilder<dynamic>(
                    future: _addProduct.getShopData(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("...");
                      }
                      return CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(snapshot.data['shop_logo']));
                    }),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: <Widget>[
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FutureBuilder<dynamic>(
                        future: _addProduct.getShopData(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text("");
                          }
                          shopName = snapshot.data['shop_name'];
                          return Text(
                            shopName.toUpperCase(),
                            style: GoogleFonts.ptSans(
                                textStyle: TextStyle(
                                    color: Color.fromRGBO(181, 7, 107, 1),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15)),
                          );
                        })
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep >= 1) return;
                setState(() {
                  _currentStep += 1;
                });
              },
              onStepCancel: () {
                if (_currentStep <= 0) return;
                setState(() {
                  _currentStep -= 1;
                });
              },
              steps: <Step>[
                Step(
                    title: Text('Step 1'),
                    content: Column(
                      children: <Widget>[
                        _productName(),
                        _productDescription(),
                        _productQuantity(),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            _uploadProductPhoto(),
                            Expanded(child: Text("Choose photo(s)"))
                          ],
                        )
                      ],
                    )),
                Step(
                    title: Text('Step 2'),
                    content: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(child: _productPrice()),
                            SizedBox(width: 30),
                            Expanded(child: _productDiscount()),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Expanded(child: _productCategory()),
                            SizedBox(width: 30),
                            Expanded(child: _gender()),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(child: _productSize()),
                            SizedBox(width: 30),
                            Expanded(child: _collection()),
                          ],
                        ),
                      ],
                    )),
              ]),
        ],
      )),
    );
  }

  Widget _productName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: "Product Name*"),
      validator: (value) => ValidateProducts.validateProductName(value.trim()),
      onSaved: (productName) => _addProduct.setproductName = productName,
    );
  }

  Widget _productSize() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: "Size"),
      onSaved: (size) => _addProduct.setproductSize = size,
    );
  }

  Widget _productPrice() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: "Price*"),
      validator: (value) => ValidateProducts.validatePrice(value.trim()),
      onSaved: (price) => _addProduct.setproductPrice = price,
    );
  }

  Widget _productDiscount() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: "Discount(%)"),
      onSaved: (discount) => _addProduct.setproductDescription = discount,
    );
  }

  Widget _productQuantity() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: "Quantity*"),
      validator: (value) => ValidateProducts.validateQuantity(value.trim()),
      onSaved: (quantity) => _addProduct.setproductQuantity = quantity,
    );
  }

  Widget _productDescription() {
    return TextFormField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(hintText: "Description"),
      inputFormatters: [
        LengthLimitingTextInputFormatter(150),
      ],
      onSaved: (productDesc) => _addProduct.setproductDescription = productDesc,
    );
  }

  Widget _productCategory() {
    return DropdownButton<String>(
      value: _addProduct.productType,
      onChanged: (String newValue) => _addProduct.setproductType = newValue,
      items: <String>[
        'Foot Wears',
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
      value: _addProduct.gender,
      onChanged: (String newValue) => _addProduct.setgender = newValue,
      items: <String>['Male', "Female"]
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
        picked: _addProduct.collection,
        orientation: GroupedButtonsOrientation.HORIZONTAL,
        padding: EdgeInsets.all(0),
        labels: <String>[
          "Kids",
          "Adults",
        ],
        onSelected: (String selected) => _addProduct.setcollection = selected);
  }

  Widget _uploadProductPhoto() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 35,
        // color: Color.fromRGBO(184, 59, 94, 1),
      ),
      onPressed: () => _addProduct.uploadProductPhotos(),
    );
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
                    "Add",
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
      onPressed: () => _addProduct.processAndSave(context),
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
// Container(
//   child: GridView.count(
//     crossAxisCount: 3,
//     children: List.generate(_addProduct.images.length, (index) {
//       Asset asset = _addProduct.images[index];
//       return AssetThumb(
//         asset: asset,
//         width: 60,
//         height: 60,
//       );
//     }),
//   ),
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: <Widget>[
//     Container(
//       height: 60,
//       width: 60,
//       color: Colors.grey,
//       child: Center(child: Text("ONE")),
//     ),
//     Container(
//       height: 60,
//       width: 60,
//       color: Colors.grey,
//       child: Center(child: Text("TWO")),
//     ),
//     Container(
//       height: 60,
//       width: 60,
//       color: Colors.grey,
//       child: Center(child: Text("THREE")),
//     ),
//     Container(
//       height: 60,
//       width: 60,
//       color: Colors.grey,
//       child: Center(child: Text("FOUR")),
//     )
//   ],
// ),
