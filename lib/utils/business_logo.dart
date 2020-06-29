import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
