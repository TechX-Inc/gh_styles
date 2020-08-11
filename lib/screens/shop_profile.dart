import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/models/shops_model.dart';
import 'package:gh_styles/models/users_auth_model.dart';
import 'package:gh_styles/providers/shop_profile_provider.dart';
import 'package:gh_styles/services/fetch_product_service.dart';
import 'package:gh_styles/services/fetch_shop_service.dart';
import 'package:gh_styles/widgets/nav_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

double computeDimensions(double percentage, double constraints) {
  return ((percentage / 100) * constraints);
}

class ShopProfile extends StatefulWidget {
  final List<ShopsModel> shopModel;
  ShopProfile({this.shopModel});
  @override
  _ShopProfileState createState() => _ShopProfileState();
}

class _ShopProfileState extends State<ShopProfile> {
  FetchShopService fetchShopService = new FetchShopService();
  ShopProfileProvider _shopProfileProvider;
  User _user;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<User>(context, listen: false);
    _shopProfileProvider =
        Provider.of<ShopProfileProvider>(context, listen: false);
    fetchShopService.setUid = _user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(245, 248, 255, 1),
        key: _shopProfileProvider.scaffoldKey,
        drawer: NavDrawer(shopsModel: widget.shopModel[0]),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(245, 248, 255, 1),
          elevation: 0,
          leading: IconButton(
            onPressed: () =>
                _shopProfileProvider.scaffoldKey.currentState.openDrawer(),
            icon: Icon(
              Icons.menu,
              color: Color.fromRGBO(132, 140, 207, 1),
            ),
          ),
        ),
        body: LayoutBuilder(builder: (context, BoxConstraints constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<List<ProductModel>>(
                stream: fetchShopService.shopProductsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: SpinKitFadingCircle(
                      color: Color.fromRGBO(0, 188, 212, 1),
                      size: 50.0,
                    ));
                  }

                  List<ProductModel> products = snapshot.data;
                  products.removeWhere((value) => value == null);
                  if (products.isEmpty || products == null) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You have no products",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(200, 200, 200, 1)),
                          ),
                          SizedBox(height: 10),
                          new OutlineButton(
                              child: new Text("New Product",
                                  style: TextStyle(color: Colors.blueAccent)),
                              onPressed: () =>
                                  Navigator.pushNamed(context, "/add_product"),
                              borderSide: BorderSide(color: Colors.blueAccent),
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)))
                        ],
                      ),
                    );
                  }
                  return ListView(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget?.shopModel[0]?.shopLogoPath != null
                              ? CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                      widget.shopModel[0]?.shopLogoPath))
                              : Container(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Total Sales",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromRGBO(140, 140, 140, 1)),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "50,000 GHS",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 16),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget?.shopModel[0]?.shopName,
                            style: GoogleFonts.kulimPark(
                                fontSize: 25,
                                color: Color.fromRGBO(132, 140, 207, 1)),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed("/edit_shop", arguments: {
                              "edit_mode": true,
                              "shop_model": widget.shopModel[0]
                            }),
                            icon: Icon(
                              Icons.edit,
                              size: 20,
                              color: Color.fromRGBO(132, 140, 207, 1),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 25,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, int index) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(247, 250, 255, 1),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(6)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
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
                                                      'assets/images/loader_network.gif',
                                                  image:
                                                      "${products[index].productPhotos[0]}",
                                                  fit: BoxFit.cover,
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
                                                      "Stock: ${products[index].productQuantity}",
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    )),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    width: double.infinity,
                                    child: Text(
                                      products[index].productName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                              color: Color.fromRGBO(
                                                  118, 118, 118, 1),
                                              fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          child: IconButton(
                                        onPressed: () => Navigator.of(context)
                                            .pushNamed("/edit_product",
                                                arguments: {
                                              "edit_mode": true,
                                              "product_model": products[index]
                                            }),
                                        icon: Icon(Icons.edit,
                                            size: 20, color: Colors.blueAccent),
                                      )),
                                      Container(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          // width: double.infinity,
                                          child: IconButton(
                                            onPressed: () => showAlertDialog(
                                                products[index]),
                                            icon: Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: Colors.redAccent,
                                            ),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            );
                          })
                    ],
                  );
                }),
          );
        }));
  }

  showAlertDialog(ProductModel productModel) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget deleteButton = FlatButton(
      child: Text(
        "Delete",
        style: TextStyle(color: Colors.redAccent),
      ),
      onPressed: () => {
        Navigator.of(context).pop(),
        _shopProfileProvider.deleteProduct(
            productModel.productPhotos, productModel.productRef)
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Delete Product"),
      content: Text("Are you sure you want to delete this product?"),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
