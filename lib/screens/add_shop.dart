import 'package:gh_styles/models/shops_model.dart';
import 'package:gh_styles/providers/shop_management_provider.dart';
import 'package:gh_styles/shop_form.dart';
import 'package:gh_styles/widgets/add_shop_form.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/widgets/business_logo_picker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddShop extends StatefulWidget {
  bool editMode;
  final ShopsModel shopsModel;

  AddShop({this.editMode = false, this.shopsModel});
  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: AddShopProvider().scaffoldKey,
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
        backgroundColor: Color.fromRGBO(248, 252, 255, 1),
        body: Container(
          padding: EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: ChangeNotifierProvider(
                        create: (context) => AddShopProvider(),
                        child: ShopForms(shopsModel: widget.shopsModel))),
              );
            },
          ),
        ),
      ),
    );
  }
}
