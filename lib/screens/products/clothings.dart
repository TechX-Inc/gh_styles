import 'package:flutter/material.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/services/fetch_product_service.dart';
import 'package:gh_styles/test_data.dart';
import 'package:gh_styles/widgets/product_grid_container.dart';

class Clothings extends StatefulWidget {
  @override
  _ClothingsState createState() => _ClothingsState();
}

class _ClothingsState extends State<Clothings> {
  FetchProductService productService = new FetchProductService();
  Stream<List<ProductModel>> clothings;

  @override
  void initState() {
    super.initState();
    clothings = productService.productsOverviewStream("type", "Clothings");
  }

  @override
  Widget build(BuildContext context) {
    return ProductGridContainer(
      productsModelStream: clothings,
      heroID: "Clothings",
    );
  }
}
