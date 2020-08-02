import 'package:flutter/material.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/services/fetch_product_service.dart';
import 'package:gh_styles/widgets/product_grid_container.dart';

class Shorts extends StatefulWidget {
  @override
  _ShortsState createState() => _ShortsState();
}

class _ShortsState extends State<Shorts> {
  FetchProductService productService = new FetchProductService();
  Stream<List<ProductModel>> shorts;

  @override
  void initState() {
    super.initState();
    shorts = productService.productsOverviewStream("type", "Shorts");
  }

  @override
  Widget build(BuildContext context) {
    return ProductGridContainer(
      productsModelStream: shorts,
      heroID: "Shorts",
    );
  }
}
