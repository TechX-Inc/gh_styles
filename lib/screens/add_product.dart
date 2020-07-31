import 'package:flutter/material.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/providers/product_management_provider.dart';
import 'package:gh_styles/widgets/add_product_form.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatelessWidget {
  final bool editMode;
  final ProductModel productModel;
  AddProduct({this.editMode = false, this.productModel});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: ChangeNotifierProvider<AddProductProvider>(
                create: (context) => AddProductProvider(),
                child: AddProductForm(productModel: productModel))),
      ),
    );
  }
}
