import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gh_styles/auth_and_validation/validation_product.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/models/shops_model.dart';
import 'package:gh_styles/models/users_auth_model.dart';
import 'package:gh_styles/providers/product_management_provider.dart';
import 'package:gh_styles/services/fetch_shop_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class AddProductForm extends StatefulWidget {
  final ProductModel productModel;
  AddProductForm({this.productModel});
  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  AddProductProvider _addProduct;
  FetchShopService fetchShopService = new FetchShopService();

  int _currentStep = 0;
  User _user;
  DocumentReference shopRef;
  String shopName = '';
  String _nextStepperToggleText = 'Next';
  Color _nextStepperToggleColor = Color.fromRGBO(32, 125, 255, 1);

  @override
  void initState() {
    super.initState();
    _user = Provider.of<User>(context, listen: false);
    _addProduct = Provider.of<AddProductProvider>(context, listen: false);
    fetchShopService.setUid = _user.uid;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.productModel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => {
            _addProduct.setcollection = widget.productModel.collection,
            _addProduct.setproductType = widget.productModel.productType,
            _addProduct.setgender = widget.productModel.gender,
            _addProduct.setExistingImage = widget.productModel.productPhotos
          });
    }

    return Consumer<AddProductProvider>(builder: (_, data, __) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(247, 250, 255, 1),
          leading: IconButton(
            color: Colors.black,
            icon: Icon(
              Icons.chevron_left,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
        ),
        key: _addProduct.scaffoldKey,
        body: ModalProgressHUD(
          inAsyncCall: data.loading,
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top: 30),
                    child: StreamBuilder<List<ShopsModel>>(
                        stream: fetchShopService.shopsStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            print(snapshot.error);
                            return Text("...");
                          }
                          if ((snapshot.data == null ||
                              snapshot.data.contains(null) ||
                              snapshot.data.isEmpty)) {
                            return Container();
                          } else {
                            WidgetsBinding.instance.addPostFrameCallback((_) =>
                                {
                                  _addProduct.setUserShopReference =
                                      snapshot.data[0].shopRef
                                });
                            return CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    snapshot.data[0].shopLogoPath));
                          }
                        }),
                  )
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
                        StreamBuilder<List<ShopsModel>>(
                            stream: fetchShopService.shopsStream(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text("");
                              }
                              if ((snapshot.data == null ||
                                  snapshot.data.contains(null) ||
                                  snapshot.data.isEmpty)) {
                                return Container();
                              } else {
                                return Text(
                                  snapshot.data[0].shopName.toUpperCase(),
                                  style: GoogleFonts.ptSans(
                                      textStyle: TextStyle(
                                          color: Color.fromRGBO(181, 7, 107, 1),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15)),
                                );
                              }
                            })
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              Form(
                key: _addProduct.formKey,
                child: Stepper(
                    physics: ClampingScrollPhysics(),
                    currentStep: _currentStep,
                    onStepContinue: () {
                      if (_currentStep >= 1) return;
                      if (_addProduct.formKeyStepperOne.currentState
                          .validate()) {
                        _addProduct.formKeyStepperOne.currentState.save();
                        setState(() {
                          _currentStep += 1;
                          _nextStepperToggleText = widget.productModel == null
                              ? 'Add'
                              : "Save Changes";
                          _nextStepperToggleColor =
                              Color.fromRGBO(181, 7, 107, 1);
                        });
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep <= 0) return;
                      setState(() {
                        _currentStep -= 1;
                        _nextStepperToggleText = 'Next';
                        _nextStepperToggleColor =
                            Color.fromRGBO(32, 125, 255, 1);
                      });
                    },
                    controlsBuilder: (BuildContext context,
                        {onStepCancel, onStepContinue}) {
                      return Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          children: <Widget>[
                            FlatButton(
                                color: _nextStepperToggleColor,
                                child: Text(
                                  _nextStepperToggleText,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: _currentStep != 1
                                    ? onStepContinue
                                    : () => widget.productModel == null
                                        ? _addProduct.processAndSave()
                                        : _addProduct.updateProduct(
                                            widget.productModel.productRef,
                                            widget.productModel.productPhotos)),
                            SizedBox(
                              width: 20,
                            ),
                            FlatButton(
                                child: Text("Previous"),
                                onPressed: onStepCancel),
                          ],
                        ),
                      );
                    },
                    steps: <Step>[
                      Step(
                          title: Text('Step 1'),
                          content: Form(
                            key: _addProduct.formKeyStepperOne,
                            child: Column(
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
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Consumer<AddProductProvider>(
                                    builder: (_, data, __) {
                                  return (data.existingImages.isNotEmpty &&
                                          data.existingImages != null)
                                      ? ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight: 80.0,
                                          ),
                                          child: LayoutBuilder(
                                            builder: (context,
                                                BoxConstraints constraint) {
                                              return Container(
                                                color: Colors.white,
                                                child: Row(
                                                  children: [
///////////////////////////////////////////////////
                                                    Expanded(
                                                      child: GridView.count(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        primary: false,
                                                        crossAxisCount: data
                                                            .computeExistingImageWidth(),
                                                        crossAxisSpacing: 10,
                                                        children: List.generate(
                                                            (data.existingImages
                                                                .length),
                                                            (index) {
                                                          return Stack(
                                                            fit:
                                                                StackFit.expand,
                                                            children: [
                                                              FadeInImage
                                                                  .assetNetwork(
                                                                placeholder:
                                                                    'assets/images/loader_network.gif',
                                                                image:
                                                                    data.existingImages[
                                                                        index],
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              Positioned(
                                                                top: 0,
                                                                right: 0,
                                                                child:
                                                                    GestureDetector(
                                                                  behavior:
                                                                      HitTestBehavior
                                                                          .translucent,
                                                                  onTap: () => data.removeProductPhoto(
                                                                      data.existingImages[
                                                                          index],
                                                                      widget
                                                                          .productModel
                                                                          .productRef,
                                                                      index),
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                      ),
                                                    ),

///////////////////////////////////////////////////////////
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Visibility(
                                                      visible: data
                                                          .images.isNotEmpty,
                                                      child: Expanded(
                                                        child: GridView.count(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          primary: false,
                                                          crossAxisCount: (data
                                                                      .images
                                                                      .length <=
                                                                  1)
                                                              ? 1
                                                              : data.images
                                                                  .length,
                                                          crossAxisSpacing: 10,
                                                          children:
                                                              List.generate(
                                                                  data.images
                                                                      .length,
                                                                  (index) {
                                                            return Stack(
                                                              fit: StackFit
                                                                  .expand,
                                                              children: [
                                                                Image.file(
                                                                  data.images[
                                                                      index],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                Positioned(
                                                                  top: 0,
                                                                  right: 0,
                                                                  child:
                                                                      GestureDetector(
                                                                    behavior:
                                                                        HitTestBehavior
                                                                            .translucent,
                                                                    onTap: () =>
                                                                        data.imageToRemoveIndex =
                                                                            index,
                                                                    child: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          }),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ))
                                      : Visibility(
                                          visible: data.images.isNotEmpty,
                                          child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxHeight: 80.0,
                                              ),
                                              child: GridView.count(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                primary: false,
                                                crossAxisCount: 4,
                                                crossAxisSpacing: 10,
                                                children: List.generate(
                                                    data.images.length,
                                                    (index) {
                                                  return Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      Image.file(
                                                        data.images[index],
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: GestureDetector(
                                                          behavior:
                                                              HitTestBehavior
                                                                  .translucent,
                                                          onTap: () {
                                                            data.imageToRemoveIndex =
                                                                index;
                                                          },
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                }),
                                              )),
                                        );
                                }),
                              ],
                            ),
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
              )
            ],
          )),
        ),
      );
    });
  }

  Widget _productName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: "Product Name*"),
      validator: (value) => ValidateProducts.validateProductName(value.trim()),
      onSaved: (productName) => _addProduct.setproductName = productName,
      initialValue:
          widget.productModel != null ? widget.productModel.productName : null,
    );
  }

  Widget _productSize() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: "Size"),
      onSaved: (size) => _addProduct.setproductSize = size,
      initialValue:
          widget.productModel != null ? widget.productModel.productSize : null,
    );
  }

  Widget _productPrice() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: "Price*"),
      validator: (value) => ValidateProducts.validatePrice(value.trim()),
      onSaved: (price) => _addProduct.setproductPrice = double.parse(price),
      initialValue: widget.productModel != null
          ? widget.productModel.productPrice.toString()
          : null,
    );
  }

  Widget _productDiscount() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: "Discount(%)"),
      onSaved: (discount) => {
        _addProduct.setproductDiscount =
            discount.isEmpty ? 0.toDouble() : double.parse(discount)
      },
      initialValue: widget.productModel != null
          ? widget.productModel.productDiscount.toString()
          : '',
    );
  }

  Widget _productQuantity() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: "Quantity*"),
      validator: (value) => ValidateProducts.validateQuantity(value.trim()),
      onSaved: (quantity) =>
          _addProduct.setproductQuantity = int.parse(quantity),
      initialValue: widget.productModel != null
          ? widget.productModel.productQuantity.toString()
          : null,
    );
  }

  Widget _productDescription() {
    return TextFormField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(hintText: "Description"),
      inputFormatters: [
        LengthLimitingTextInputFormatter(400),
      ],
      onSaved: (productDesc) => _addProduct.setproductDescription = productDesc,
      initialValue: widget.productModel != null
          ? widget.productModel.productDescription
          : null,
    );
  }

  Widget _productCategory() {
    return Consumer<AddProductProvider>(builder: (_, data, __) {
      return DropdownButton<String>(
        value: data.productType,
        onChanged: (String value) => data.setproductType = value,
        items: <String>[
          'Footwears',
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
    });
  }

  Widget _gender() {
    return Consumer<AddProductProvider>(builder: (_, data, __) {
      return DropdownButton<String>(
        value: data.gender,
        onChanged: (String newValue) => data.setgender = newValue,
        items: <String>['Male', "Female"]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }

  Widget _collection() {
    return Consumer<AddProductProvider>(builder: (_, data, __) {
      return RadioButtonGroup(
          picked: data.collection,
          orientation: GroupedButtonsOrientation.HORIZONTAL,
          padding: EdgeInsets.all(0),
          labels: <String>[
            "Kids",
            "Adults",
          ],
          onSelected: (String selected) => data.setcollection = selected);
    });
  }

  Widget _uploadProductPhoto() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 35,
        // color: Color.fromRGBO(184, 59, 94, 1),
      ),
      onPressed: () => _addProduct.selectProductPhotos(context),
    );
  }

  // Widget _signInBtn() {
  //   return RaisedButton(
  //     color: Color.fromRGBO(181, 7, 107, 1),
  //     child: FractionallySizedBox(
  //       widthFactor: 1,
  //       child: Container(child: Consumer<AddProductProvider>(
  //         builder: (context, data, _) {
  //           return !data.loading
  //               ? Text(
  //                   "Add",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(color: Colors.white),
  //                 )
  //               : SpinKitThreeBounce(
  //                   color: Colors.white,
  //                   size: 25.0,
  //                 );
  //         },
  //       )),
  //     ),
  //     shape: new RoundedRectangleBorder(
  //         borderRadius: new BorderRadius.circular(30.0)),
  //     onPressed: () => _addProduct.processAndSave(context),
  //   );
  // }
}
