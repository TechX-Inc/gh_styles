import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/providers/HomeScreenStickyHeaderProvider.dart';
import 'package:gh_styles/providers/product_details_provider.dart';
import 'package:gh_styles/screens/products/product_details.dart';
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
  HomeScreenStickyHeaderProvider _homeHeaderProvider;
  final f = new NumberFormat("###.0#", "en_US");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homeHeaderProvider =
        Provider.of<HomeScreenStickyHeaderProvider>(context, listen: false);
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
                            style: Theme.of(context).textTheme.headline6.apply(
                                  fontWeightDelta: 2,
                                ),
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
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Container(
                                          color: Colors.white,
                                          child: GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChangeNotifierProvider<
                                                              ProductDetailsProvider>(
                                                          create: (context) =>
                                                              ProductDetailsProvider(),
                                                          builder: (context,
                                                              snapshot) {
                                                            return DetailsScreen(
                                                              productModel:
                                                                  products[
                                                                      index],
                                                              heroID:
                                                                  '$index${widget.heroID}',
                                                            );
                                                          }),
                                                )),
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "\₵${computePrice(products[index].productDiscount, products[index].productPrice)}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      34,
                                                                      40,
                                                                      49,
                                                                      1),
                                                              fontSize: 18),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Hero(
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
                                                              fit: BoxFit.fill,
                                                            ),
                                                            products[index]
                                                                        .productDiscount
                                                                        .toString() !=
                                                                    "0"
                                                                ? Positioned(
                                                                    top: 0,
                                                                    right: 0,
                                                                    child:
                                                                        Badge(
                                                                      badgeColor:
                                                                          Color.fromRGBO(
                                                                              148,
                                                                              15,
                                                                              55,
                                                                              1),
                                                                      shape: BadgeShape
                                                                          .square,
                                                                      borderRadius:
                                                                          20,
                                                                      toAnimate:
                                                                          false,
                                                                      badgeContent: Text(
                                                                          '-${products[index].productDiscount.toString()}%',
                                                                          style:
                                                                              TextStyle(color: Colors.white)),
                                                                    ),
                                                                  )
                                                                : Container()
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
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
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 17),
                                                    ),
                                                  )
                                                ],
                                              ),
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

  String computePrice(String discountString, String priceString) {
    double discount = double.parse(discountString);
    double price = double.parse(priceString);
    String productPrice;
    if (discount <= 0) {
      productPrice = price.toString();
    } else {
      productPrice = (price - (discount / 100) * price).toString();
    }
    return f.format(double.parse(productPrice));
  }
}