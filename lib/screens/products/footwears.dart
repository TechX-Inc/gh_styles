import 'package:flutter/material.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/services/fetch_product_service.dart';
import 'package:gh_styles/widgets/product_grid_container.dart';

class Footwears extends StatefulWidget {
  @override
  _FootwearsState createState() => _FootwearsState();
}

class _FootwearsState extends State<Footwears> {
  FetchProductService productService = new FetchProductService();
  Stream<List<ProductModel>> footwears;

  @override
  void initState() {
    super.initState();
    footwears = productService.productsOverviewStream("type", "Footwears");
  }

  @override
  Widget build(BuildContext context) {
    return ProductGridContainer(
      productsModelStream: footwears,
      producCategorytKey: "type",
      productCategoryValue: "Footwears",
    );
  }
}
