import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/models/shops_model.dart';
import 'package:gh_styles/test_data.dart';

class ShopProfile extends StatefulWidget {
  final List<ShopsModel> shopModel;
  ShopProfile({this.shopModel});
  @override
  _ShopProfileState createState() => _ShopProfileState();
}

class _ShopProfileState extends State<ShopProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 250,
          ),
          child: Container(
            // color: Color.fromRGBO(250, 250, 230, 1),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "\₵0.00",
                        style: TextStyle(color: Colors.green, fontSize: 30),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Total Sales",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "0",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 30),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Total Customers",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
              // color: Colors.red,
              color: Colors.white,
              width: double.infinity,
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 25,
                  ),
                  itemCount: productsList.length,
                  itemBuilder: (context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _showBottomSheet();
                      },
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: FractionallySizedBox(
                                    widthFactor: 0.9,
                                    heightFactor: 1.0,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            "${productsList[index].img}",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 5,
                                          right: 5,
                                          child: Badge(
                                              padding: EdgeInsets.all(6),
                                              badgeColor: Colors.white,
                                              borderRadius: 20,
                                              shape: BadgeShape.square,
                                              toAnimate: false,
                                              badgeContent: Text("Stock: 20")),
                                        ),
                                      ],
                                    )),
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
                                "TITLE",
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

                      //  Card(
                      //     elevation: 0,
                      //     color: Colors.white,
                      //     child: Stack(
                      //       fit: StackFit.expand,
                      //       children: [
                      //         ClipRRect(
                      //           borderRadius: BorderRadius.circular(8.0),
                      //           child: Image.asset(
                      //             "${productsList[index].img}",
                      //             fit: BoxFit.fill,
                      //           ),
                      //         ),
                      //         Positioned(
                      //           bottom: 5,
                      //           right: 5,
                      //           child: Badge(
                      //               padding: EdgeInsets.all(6),
                      //               badgeColor: Colors.white,
                      //               borderRadius: 20,
                      //               shape: BadgeShape.square,
                      //               toAnimate: false,
                      //               badgeContent: Text("Stock: 20")),
                      //         ),
                      //       ],
                      //     )),
                    );
                  })),
        ),
      ],
    ));
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 100,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new OutlineButton(
                          child: new Text(
                            "Edit",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                          onPressed: () {
                            print("Editing...");
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0))),
                      OutlineButton(
                          child: new Text(
                            "Delete",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          onPressed: () {
                            print("Deleting...");
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0))),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
