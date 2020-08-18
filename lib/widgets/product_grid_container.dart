import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/providers/main_app_state_provider.dart';
import 'package:badges/badges.dart';
import 'package:gh_styles/services/fetch_product_service.dart';
import 'package:gh_styles/widgets/shimmer.dart';
import 'package:provider/provider.dart';

class ProductGridContainer extends StatefulWidget {
  final Stream<List<ProductModel>> productsModelStream;
  final String producCategorytKey;
  final String productCategoryValue;
  const ProductGridContainer(
      {this.productsModelStream,
      this.producCategorytKey,
      this.productCategoryValue,
      Key key})
      : super(key: key);

  @override
  _ProductGridContainerState createState() => _ProductGridContainerState();
}

class _ProductGridContainerState extends State<ProductGridContainer> {
  MainAppStateProvider _mainAppStateProvider;
  FetchProductService _productService = new FetchProductService();
  List<ProductModel> productModelList;

  StreamController<List<ProductModel>> _streamController =
      StreamController<List<ProductModel>>.broadcast();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mainAppStateProvider =
        Provider.of<MainAppStateProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        child: StreamBuilder<List<ProductModel>>(
            stream: widget.productsModelStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return ShimmerLoaderVertical();
              }

              productModelList = snapshot.data;
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _mainAppStateProvider.setscrollEnabled = true);

              return productModelList.isNotEmpty
                  ? NotificationListener<ScrollNotification>(
                      // ignore: missing_return
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!isLoading &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
                          _loadData();
                          setState(() {
                            isLoading = true;
                          });
                        }
                      },
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          GridView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 25,
                                      childAspectRatio: .8),
                              itemCount: productModelList.length,
                              itemBuilder: (context, int index) {
                                return GestureDetector(
                                  onTap: () => Navigator.of(context).pushNamed(
                                      "/product_details",
                                      arguments: {
                                        "product_model":
                                            productModelList[index],
                                        "hero_id":
                                            '$index${widget.productCategoryValue}',
                                        "index": index
                                      }),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "\₵${_mainAppStateProvider.computePrice(productModelList[index].productDiscount, productModelList[index].productPrice)}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    color: Color.fromRGBO(
                                                        82, 87, 93, 1),
                                                    fontSize: 18),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Hero(
                                                transitionOnUserGestures: true,
                                                tag:
                                                    '$index${widget.productCategoryValue}',
                                                placeholderBuilder:
                                                    (context, heroSize, child) {
                                                  return Container(
                                                    height: 150.0,
                                                    width: 150.0,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                                child: FractionallySizedBox(
                                                    widthFactor: 0.9,
                                                    heightFactor: 1.0,
                                                    child: Stack(
                                                      fit: StackFit.expand,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: FadeInImage
                                                              .assetNetwork(
                                                            placeholder:
                                                                'assets/images/loading.gif',
                                                            image:
                                                                "${productModelList[index].productPhotos[0]}",
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        productModelList[index]
                                                                    .productDiscount
                                                                    .toInt() !=
                                                                0
                                                            ? Positioned(
                                                                top: 0,
                                                                right: 0,
                                                                child: Badge(
                                                                  badgeColor: Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          103,
                                                                          125,
                                                                          1),
                                                                  // badgeColor: Color.fromRGBO(231, 48, 91, 1),
                                                                  shape:
                                                                      BadgeShape
                                                                          .square,
                                                                  borderRadius:
                                                                      20,
                                                                  toAnimate:
                                                                      false,
                                                                  badgeContent: Text(
                                                                      '-${productModelList[index].productDiscount.toInt()}%',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                ),
                                                              )
                                                            : Container()
                                                      ],
                                                    ))),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                          // alignment: Alignment.center,
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          width: double.infinity,

                                          child: Text(
                                            "${productModelList[index].productName}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 17),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          isLoading
                              ? Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 10),
                                  child: StreamBuilder<List<ProductModel>>(
                                      stream: _productService
                                          .loadMoreProductsStream(
                                              productModelList.last,
                                              widget.producCategorytKey,
                                              widget.productCategoryValue),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container(
                                              alignment: Alignment.center,
                                              height: 30,
                                              child: SpinKitRing(
                                                  color: Colors.blueAccent));
                                        }
                                        if (snapshot.data.isEmpty) {
                                          return Center(
                                            child: Text("No more products",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      200, 200, 200, 1),
                                                )),
                                          );
                                        }
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          setState(() {
                                            productModelList
                                                .addAll(snapshot.data);
                                            isLoading = false;
                                          });
                                        });
                                        return Container();
                                      }),
                                )
                              : Container()
                        ],
                      ),
                    )
                  : LayoutBuilder(builder: (context, constraints) {
                      return ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            height: MediaQuery.of(context).size.height / 2),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          // color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.hourglass_empty,
                                  color: Color.fromRGBO(200, 200, 200, 1)),
                              SizedBox(height: 10),
                              Text(
                                "No Data",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(200, 200, 200, 1)),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
            }),
      );
    });
  }

  void _loadData() {
    // print("hello");
  }
}
