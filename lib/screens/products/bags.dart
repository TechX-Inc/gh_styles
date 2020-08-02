import 'package:flutter/material.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/services/fetch_product_service.dart';
import 'package:gh_styles/widgets/product_grid_container.dart';

class Bags extends StatefulWidget {
  @override
  _BagsState createState() => _BagsState();
}

class _BagsState extends State<Bags> {
  FetchProductService productService = new FetchProductService();
  Stream<List<ProductModel>> bags;

  @override
  void initState() {
    super.initState();
    bags = productService.productsOverviewStream("type", "Bags");
  }

  @override
  Widget build(BuildContext context) {
    return ProductGridContainer(
      productsModelStream: bags,
      heroID: "Bags",
    );
  }
}
