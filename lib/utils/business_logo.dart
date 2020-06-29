import 'package:flutter/material.dart';
import 'package:gh_styles/providers/add_shop_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ShopLogo extends StatefulWidget {
  ShopLogo({Key key}) : super(key: key);
  @override
  _ShopLogoState createState() => _ShopLogoState();
}

class _ShopLogoState extends State<ShopLogo> {
  AddShopProvider logoUploadHandler;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logoUploadHandler = Provider.of<AddShopProvider>(context, listen: false);
    // print("<<<<<<<==============TEST PRINT COUNT=============>>>>>>>>>>");
    return Container(
        margin: EdgeInsets.only(top: 20),
        width: 65.0,
        height: 65.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: Consumer<AddShopProvider>(builder: (context, data, _) {
          // print(data.image);
          return IconButton(
              icon: Icon(
                Icons.add_a_photo,
                color: Color.fromRGBO(109, 0, 39, 1),
                size: 30.0,
              ),
              onPressed: () {
                data.pickImage();
              });
        }));
  }
}
