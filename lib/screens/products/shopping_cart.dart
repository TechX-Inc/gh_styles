import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/test_data.dart';

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "My Cart",
            style: TextStyle(color: Colors.black),
          ),
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
            FlatButton(
                child: Text(
                  "Clear All",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () => print("HELLO")),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
                height: computeDimensions(100, constraints.maxHeight),
                width: constraints.maxWidth,
                child: Column(
                  children: [
                    Container(
                        // color: Colors.amber,
                        height: computeDimensions(90, constraints.maxHeight),
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: double.infinity,
                            ),
                            child: ListView.builder(
                                itemCount: productsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Dismissible(
                                    key: ValueKey("${index}CART"),
                                    child: ListTile(
                                      title: Container(
                                          height: 130,
                                          child: LayoutBuilder(
                                            builder:
                                                (context, listTileConstraints) {
                                              return Row(
                                                children: [
                                                  Container(
                                                      // color: Colors.red,
                                                      height: computeDimensions(
                                                          100,
                                                          listTileConstraints
                                                              .maxHeight),
                                                      width: computeDimensions(
                                                          40,
                                                          listTileConstraints
                                                              .maxWidth),
                                                      child: Image.asset(
                                                        productsList[index].img,
                                                        fit: BoxFit.fill,
                                                      )),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            productsList[index]
                                                                .title,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        100,
                                                                        100,
                                                                        100,
                                                                        1)),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Container(
                                                          child: Text(
                                                            productsList[index]
                                                                .price,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        50,
                                                                        219,
                                                                        198,
                                                                        1)),
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        Container(
                                                          child: Badge(
                                                            elevation: 0,
                                                            badgeColor:
                                                                Color.fromRGBO(
                                                                    231,
                                                                    48,
                                                                    91,
                                                                    1),
                                                            shape: BadgeShape
                                                                .square,
                                                            borderRadius: 20,
                                                            toAnimate: false,
                                                            badgeContent: Text(
                                                                'Quantity: 5',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.close,
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                        onPressed: () {
                                                          print(index);
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              );
                                            },
                                          )),
                                    ),
                                    onDismissed: (direction) {
                                      print(index);
                                    },
                                  );
                                }))),
                    Container(
                      height: computeDimensions(10, constraints.maxHeight),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Text(
                                "349 GHS",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 10, top: 15),
                              child: RaisedButton(
                                color: Color.fromRGBO(231, 48, 91, 1),
                                onPressed: () {
                                  print("Checking out");
                                },
                                child: Text(
                                  "Checkout",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Color.fromRGBO(250, 250, 250, 1)))),
                    )
                  ],
                ));
          },
        ),
      ),
    );
  }

  double computeDimensions(double percentage, double constraintHeight) {
    return ((percentage / 100) * constraintHeight);
  }
}
