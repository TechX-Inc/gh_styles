import 'package:flutter/material.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/services/fetch_product_service.dart';
import 'package:gh_styles/widgets/page_header_banner.dart';
import 'package:gh_styles/widgets/product_horizontal_list_container.dart';

class ProductsOverView extends StatefulWidget {
  @override
  _ProductsOverViewState createState() => _ProductsOverViewState();
}

class _ProductsOverViewState extends State<ProductsOverView> {
  FetchProductService productService = new FetchProductService();
  Stream<List<ProductModel>> shirts;
  Stream<List<ProductModel>> bags;
  Stream<List<ProductModel>> kidsProduct;
  Stream<List<ProductModel>> footwears;
  Stream<List<ProductModel>> shorts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shirts = productService.productsOverviewStream("type", "Shirts");
    bags = productService.productsOverviewStream("type", "Bags");
    kidsProduct = productService.productsOverviewStream("collection", "Kids");
    footwears = productService.productsOverviewStream("type", "Footwears");
    shorts = productService.productsOverviewStream("type", "Shorts");
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PageBanner(),
          SizedBox(
            height: 10,
          ),
          ProductHorizontalListContainer(
            productsModelStream: FetchProductService().newProductsStream,
            heroID: "NEW_PRODUCTS_HERO",
            sectionHeader: "New Arrivals",
            sectionTopMargin: 0,
          ),
          ProductHorizontalListContainer(
            productsModelStream: shirts,
            heroID: "SHIRTS_HERO",
            sectionHeader: "Shirts",
            sectionTopMargin: 50,
          ),
          ProductHorizontalListContainer(
            productsModelStream: bags,
            heroID: "BAGS_HERO",
            sectionHeader: "Bags",
            sectionTopMargin: 50,
          ),
          ProductHorizontalListContainer(
            productsModelStream: shorts,
            heroID: "SHORTS_HERO",
            sectionHeader: "Shorts",
            sectionTopMargin: 50,
          ),
          ProductHorizontalListContainer(
            productsModelStream: kidsProduct,
            heroID: "KIDS_HERO",
            sectionHeader: "Kids'",
            sectionTopMargin: 50,
          ),
          ProductHorizontalListContainer(
            productsModelStream: footwears,
            heroID: "FOOTWEARS_HERO",
            sectionHeader: "Footwears",
            sectionTopMargin: 50,
          )
        ],
      ),
    );
  }
}
