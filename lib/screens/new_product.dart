import 'package:flutter/material.dart';
import 'package:gh_styles/providers/add_product_provider.dart';
import 'package:gh_styles/widgets/add_product_form.dart';
import 'package:provider/provider.dart';

class NewProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: ChangeNotifierProvider<AddProductProvider>(
                create: (context) => AddProductProvider(),
                child: NewProductForm())),
      ),
    );
  }
}
