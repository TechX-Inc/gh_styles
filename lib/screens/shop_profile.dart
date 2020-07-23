import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/models/shops_model.dart';
import 'package:gh_styles/services/fetch_product_service.dart';
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
            maxHeight: 200,
          ),
          child: Container(
            // color: Color.fromRGBO(250, 250, 230, 1),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                  widget.shopModel[0].shopLogoPath)),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              widget.shopModel[0].shopName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              "\₵500 SOLD",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(200, 200, 200, 1)),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topRight,
                          child: new OutlineButton(
                              child: new Text(
                                "Edit Shop",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              onPressed: () {
                                print("Editing shop...");
                              },
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0))),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: Text(
                            "My Products",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(200, 200, 200, 1)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<ProductModel>>(
              stream: FetchProductService().allProductsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text("Loading"));
                }
                List<ProductModel> products = snapshot.data;
                return Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 25,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, int index) {
                          return GestureDetector(
                            onTap: () {
                              _showBottomSheet();
                            },
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      'assets/images/loading.gif',
                                                  image:
                                                      "${products[index].productPhotos[0]}",
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
                                                    badgeContent: Text(
                                                        "Stock: ${products[index].productQuantity}")),
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
                                      products[index].productName,
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
                        }));
              }),
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
