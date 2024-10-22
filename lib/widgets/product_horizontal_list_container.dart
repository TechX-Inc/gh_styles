import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/providers/main_app_state_provider.dart';
import 'package:gh_styles/widgets/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductHorizontalListContainer extends StatefulWidget {
  final Stream<List<ProductModel>> productsModelStream;
  final String heroID;
  final String sectionHeader;
  final double sectionTopMargin;
  ProductHorizontalListContainer(
      {this.productsModelStream,
      this.heroID,
      this.sectionHeader,
      this.sectionTopMargin});

  @override
  _ProductHorizontalListContainerState createState() =>
      _ProductHorizontalListContainerState();
}

class _ProductHorizontalListContainerState
    extends State<ProductHorizontalListContainer> {
  MainAppStateProvider _homeHeaderProvider;
  final f = new NumberFormat("###.0#", "en_US");
  @override
  void initState() {
    super.initState();
    _homeHeaderProvider =
        Provider.of<MainAppStateProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductModel>>(
        stream: widget.productsModelStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: widget.sectionTopMargin,
                ),
                ShimmerLoaderHorizontal(),
              ],
            );
          }

          WidgetsBinding.instance.addPostFrameCallback(
              (_) => _homeHeaderProvider.setscrollEnabled = true);

          List<ProductModel> products = snapshot.data;
          return products.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: widget.sectionTopMargin,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 35.0,
                        maxHeight: 240.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.sectionHeader,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .apply(
                                  fontWeightDelta: 2,
                                )
                                .copyWith(
                                    color: Color.fromRGBO(150, 150, 150, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: products.length,
                                itemBuilder: (context, int index) {
                                  return Row(
                                    children: [
                                      Container(
                                        // color: Colors.red,
                                        // color: Color.fromRGBO(250, 252, 255, 1),
                                        child: GestureDetector(
                                          onTap: () => Navigator.of(context)
                                              .pushNamed("/product_details",
                                                  arguments: {
                                                "product_model":
                                                    products[index],
                                                "hero_id":
                                                    '$index${widget.heroID}',
                                                "index": index
                                              }),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minWidth: 160.0,
                                              maxWidth: 170.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "\₵${computePrice(products[index].productDiscount, products[index].productPrice)}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        .copyWith(
                                                            color:
                                                                Color.fromRGBO(
                                                                    82,
                                                                    87,
                                                                    93,
                                                                    1),
                                                            fontSize: 18),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Hero(
                                                    transitionOnUserGestures:
                                                        true,
                                                    placeholderBuilder:
                                                        (context, heroSize,
                                                            child) {
                                                      return Container(
                                                        height: 100.0,
                                                        width: 100.0,
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    },
                                                    tag:
                                                        '$index${widget.heroID}',
                                                    child: Stack(
                                                      fit: StackFit.expand,
                                                      children: [
                                                        FadeInImage
                                                            .assetNetwork(
                                                          placeholder:
                                                              'assets/images/loading.gif',
                                                          image:
                                                              "${products[index].productPhotos[0]}",
                                                          fit: BoxFit.cover,
                                                        ),
                                                        products[index]
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
                                                                  shape:
                                                                      BadgeShape
                                                                          .square,
                                                                  borderRadius:
                                                                      20,
                                                                  toAnimate:
                                                                      false,
                                                                  badgeContent: Text(
                                                                      '-${products[index].productDiscount.toInt()}%',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                ),
                                                              )
                                                            : Container()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 3.0),
                                                  width: double.infinity,
                                                  child: Text(
                                                    "${products[index].productName}",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      )
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container();
        });
  }

  String computePrice(double discount, double price) {
    String productPrice;
    if (discount <= 0) {
      productPrice = price.toString();
    } else {
      productPrice = (price - (discount / 100) * price).toString();
    }
    return f.format(double.parse(productPrice));
  }
}
