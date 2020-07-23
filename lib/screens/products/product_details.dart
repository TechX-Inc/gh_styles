import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/screens/products/product_quantity_counter.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatelessWidget {
  final ProductModel productModel;
  final String heroID;
  final f = new NumberFormat("###.0#", "en_US");

  DetailsScreen({Key key, this.productModel, this.heroID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                  onPressed: () => Navigator.pushNamed(context, 'orderscreen')),
            ],
          ),
          backgroundColor: Color(0xfff9f9f9),
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                    maxHeight: double.infinity,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: viewportConstraints.maxWidth,
                        height: computeDimensions(
                            50, viewportConstraints.maxHeight),
                        // color: Colors.red,
                        child: Hero(
                            tag: '$heroID',
                            child: Image.network(
                              "${productModel.productPhotos[0]}",
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width * .7,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "${productModel.productName}",
                                style: TextStyle(fontSize: 28),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpandablePanel(
                          header: Text(
                            "More",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          collapsed: Text(
                            "${productModel.productDescription}",
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 17),
                          ),
                          expanded: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${productModel.productDescription}",
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 17,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Our Website",
                                softWrap: true,
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Company website",
                                softWrap: true,
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ProductQuantityCounter(),
                            Text(
                              "\₵${f.format(double.parse(productModel.productPrice))}",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.phone),
                              onPressed: () {},
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Expanded(
                              // width: double.infinity,
                              child: RaisedButton(
                                child: Text(
                                  "Add To Cart",
                                  style:
                                      Theme.of(context).textTheme.button.apply(
                                            color: Colors.white,
                                          ),
                                ),
                                onPressed: () {},
                                color: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
          // Column(
          //   children: <Widget>[
          //     Expanded(
          //       child: Stack(
          //         children: <Widget>[
          //           Positioned(
          //             top: 0,
          //             left: 0,
          //             right: 0,
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: <Widget>[
          // IconButton(
          //   icon: Icon(
          //     Icons.chevron_left,
          //   ),
          //   onPressed: () => Navigator.pop(context),
          // ),
          // IconButton(
          //     icon: Icon(
          //       Icons.shopping_cart,
          //     ),
          //     onPressed: () =>
          //         Navigator.pushNamed(context, 'orderscreen')),
          //               ],
          //             ),
          //           ),
          //           Positioned.fill(
          //             child: Container(
          //               width: double.infinity,
          //               alignment: Alignment.center,
          // child: Hero(
          //   tag: '$heroID',
          //   child: Image.network(
          //     "${productModel.productPhotos[0]}",
          //     fit: BoxFit.fill,
          //     width: MediaQuery.of(context).size.width * .7,
          //   ),
          //               ),
          //             ),
          //           )
          //         ],
          //       ),
          //     ),
          //     Expanded(
          // child: Container(
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(25.0),
          //       topRight: Radius.circular(25.0),
          //     ),
          //   ),
          //   padding: const EdgeInsets.all(15.0),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: <Widget>[
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Expanded(
          //       child: Text(
          //         "${productModel.productName}",
          //         style: Theme.of(context).textTheme.headline4,
          //       ),
          //     ),
          //     IconButton(
          //       icon: Icon(
          //         Icons.favorite_border,
          //         color: Colors.red,
          //       ),
          //       onPressed: () {},
          //     ),
          //   ],
          // ),
          //             Text(
          //               "Description",
          //               style: Theme.of(context).textTheme.headline6,
          //             ),
          //             Text(
          //               "${productModel.productDescription}",
          //             ),
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: <Widget>[
          //                 ProductQuantityCounter(),
          //                 Text(
          //                   "\₵${productModel.productPrice}",
          //                   style: Theme.of(context).textTheme.headline6,
          //                 ),
          //               ],
          //             ),
          // Container(
          //   width: double.infinity,
          //   child: RaisedButton(
          //     child: Text(
          //       "Add To Cart",
          //       style: Theme.of(context).textTheme.button.apply(
          //             color: Colors.white,
          //           ),
          //     ),
          //     onPressed: () {},
          //     color: Colors.redAccent,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(5.0),
          //     ),
          //   ),
          // )
          //           ],
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          ),
    );
  }

  double computeDimensions(double percentage, double constraintHeight) {
    return ((percentage / 100) * constraintHeight);
  }
}
