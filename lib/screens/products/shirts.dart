import 'package:flutter/material.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/services/fetch_product_service.dart';
import 'package:gh_styles/widgets/product_grid_container.dart';

class Shirts extends StatefulWidget {
  @override
  _ShirtsState createState() => _ShirtsState();
}

class _ShirtsState extends State<Shirts> {
  FetchProductService productService = new FetchProductService();
  Stream<List<ProductModel>> shirts;

  @override
  void initState() {
    super.initState();
    shirts = productService.productsOverviewStream("type", "Shirts");
  }

  @override
  Widget build(BuildContext context) {
    return ProductGridContainer(
      productsModelStream: shirts,
      producCategorytKey: "type",
      productCategoryValue: "Shirts",
    );
  }
}
