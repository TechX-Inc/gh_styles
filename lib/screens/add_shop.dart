import 'package:gh_styles/providers/add_shop_provider.dart';
import 'package:gh_styles/utils/add_shop_form.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/utils/business_logo_picker.dart';
import 'package:provider/provider.dart';

class AddShop extends StatefulWidget {
  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: Color.fromRGBO(109, 0, 39, 1),
      // color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                  child: ChangeNotifierProvider(
                      create: (context) => AddShopProvider(),
                      child: FormWrapper())),
            ),
          );
        },
      ),
    );
  }
}

class FormWrapper extends StatelessWidget {
  @override
  AddShopProvider cancelUpload;
  Widget build(BuildContext context) {
    cancelUpload = Provider.of<AddShopProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        FractionallySizedBox(
          widthFactor: 1,
          child: Container(
              // width: 200,
              // color: Colors.green,
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ShopLogo(),
              SizedBox(
                height: 10,
              ),
              Consumer<AddShopProvider>(
                builder: (context, data, _) {
                  return data.image == null
                      ? Text(
                          "Add Logo",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )
                      : FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          child: Icon(Icons.cancel, color: Colors.white),
                          onPressed: () {
                            data.removePhoto = null;
                          },
                        );
                },
              ),
              SizedBox(
                height: 40,
              ),
            ],
          )),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: ShopForms(),
          ),
        ),
      ],
    );
  }
}
