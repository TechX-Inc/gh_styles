import 'package:flutter/material.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/providers/HomeScreenStickyHeaderProvider.dart';
import 'package:gh_styles/providers/product_details_provider.dart';
import 'package:gh_styles/screens/products/product_details.dart';
import 'package:badges/badges.dart';
import 'package:gh_styles/widgets/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductGridContainer extends StatefulWidget {
  final Stream<List<ProductModel>> productsModelStream;
  final String heroID;
  const ProductGridContainer({this.productsModelStream, this.heroID, Key key})
      : super(key: key);

  @override
  _ProductGridContainerState createState() => _ProductGridContainerState();
}

class _ProductGridContainerState extends State<ProductGridContainer> {
  HomeScreenStickyHeaderProvider _homeHeaderProvider;
  final f = new NumberFormat("###.0#", "en_US");
  @override
  void initState() {
    super.initState();
    _homeHeaderProvider =
        Provider.of<HomeScreenStickyHeaderProvider>(context, listen: false);
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

              List<ProductModel> products = snapshot.data;
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _homeHeaderProvider.setscrollEnabled = true);

              return products.isNotEmpty
                  ? GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 25,
                          childAspectRatio: .8),
                      itemCount: products.length,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamed("/product_details", arguments: {
                            "product_model": products[index],
                            "hero_id": '$index${widget.heroID}'
                          }),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "\₵${computePrice(products[index].productDiscount, products[index].productPrice)}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                            color:
                                                Color.fromRGBO(82, 87, 93, 1),
                                            fontSize: 18),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Hero(
                                        tag: '$index${widget.heroID}',
                                        child: FractionallySizedBox(
                                            widthFactor: 0.9,
                                            heightFactor: 1.0,
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        'assets/images/loading.gif',
                                                    image:
                                                        "${products[index].productPhotos[0]}",
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                products[index]
                                                            .productDiscount
                                                            .toInt() !=
                                                        0
                                                    ? Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: Badge(
                                                          badgeColor:
                                                              Color.fromRGBO(
                                                                  148,
                                                                  15,
                                                                  55,
                                                                  1),
                                                          // badgeColor: Color.fromRGBO(231, 48, 91, 1),
                                                          shape:
                                                              BadgeShape.square,
                                                          borderRadius: 20,
                                                          toAnimate: false,
                                                          badgeContent: Text(
                                                              '-${products[index].productDiscount.toInt()}%',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
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
                                  padding: const EdgeInsets.only(left: 10.0),
                                  width: double.infinity,

                                  child: Text(
                                    "${products[index].productName}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                            color: Colors.black, fontSize: 17),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      })
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

  String computePrice(double discount, double price) {
    // double discount = double.parse(discountString);
    // double price = double.parse(priceString);
    String productPrice;
    if (discount <= 0) {
      productPrice = price.toString();
    } else {
      productPrice = (price - (discount / 100) * price).toString();
    }
    return f.format(double.parse(productPrice));
  }
}
