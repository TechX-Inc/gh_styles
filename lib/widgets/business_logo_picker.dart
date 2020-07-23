import 'package:flutter/material.dart';
import 'package:gh_styles/providers/add_shop_provider.dart';
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
    return Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: Consumer<AddShopProvider>(builder: (context, data, _) {
          return data.image != null
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 650),
                  height: 70,
                  width: 70,
                  child: CircleAvatar(
                      radius: 20, backgroundImage: FileImage(data.image)))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Color.fromRGBO(109, 0, 39, 1),
                        size: 30.0,
                      ),
                      onPressed: () {
                        data.pickImage();
                      }),
                );
        }));
  }
}
