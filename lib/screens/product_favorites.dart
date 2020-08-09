import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gh_styles/models/cart_model.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/models/users_auth_model.dart';
import 'package:gh_styles/services/fetch_cart_service.dart';
import 'package:gh_styles/services/fetch_product_service.dart';
import 'package:gh_styles/services/products_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

double computeDimensions(double percentage, double constraintHeight) {
  return ((percentage / 100) * constraintHeight);
}

final f = new NumberFormat("###.0#", "en_US");

String computePrice(double discount, double price) {
  String productPrice;
  if (discount <= 0) {
    productPrice = price.toString();
  } else {
    productPrice = (price - (discount / 100) * price).toString();
  }
  return f.format(double.parse(productPrice));
}

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  User user;
  final FetchCartService _cartService = new FetchCartService();
  FetchProductService _productService = new FetchProductService();
  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(247, 250, 255, 1),
        elevation: 0.0,
        centerTitle: false,
        title: Text(
          'Favourites',
          style: GoogleFonts.sintony(
            textStyle: TextStyle(
                letterSpacing: .5,
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: StreamBuilder<List<CartModel>>(
                stream: _cartService.shoppingCartProductStream(user?.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    print(snapshot.error);
                    return Center(child: Icon(Icons.shopping_cart));
                  }
                  List<CartModel> cartData = snapshot?.data;
                  cartData.removeWhere((value) => value == null);
                  return Center(
                    child: cartData.length <= 0
                        ? IconButton(
                            color: Colors.black,
                            icon: Icon(Icons.shopping_cart),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/cart'))
                        : Badge(
                            position: BadgePosition.topRight(top: 0, right: 3),
                            animationDuration: Duration(milliseconds: 300),
                            animationType: BadgeAnimationType.slide,
                            badgeContent: Text(
                              "${cartData.length}",
                              style: TextStyle(color: Colors.white),
                            ),
                            child: IconButton(
                                color: Colors.black,
                                icon: Icon(Icons.shopping_cart),
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/cart')),
                          ),
                  );
                }),
          )
        ],
      ),
      backgroundColor: Color.fromRGBO(248, 252, 255, 1),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<List<ProductModel>>(
                  stream: _productService.userFavouritesStream(user.uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: SpinKitFadingCircle(
                        color: Color.fromRGBO(0, 188, 212, 1),
                        size: 50.0,
                      ));
                    }
                    List<ProductModel> favourites = snapshot.data;
                    favourites.removeWhere((value) => value == null);
                    return favourites.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.only(top: 30),
                            itemCount: favourites.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  return Navigator.of(context).pushNamed(
                                      "/product_details",
                                      arguments: {
                                        "product_model": favourites[index],
                                        "index": index
                                      });
                                },
                                child: FavouriteListTile(
                                  index: index,
                                  productModel: favourites[index],
                                  user: user,
                                ),
                              );
                            },
                          )
                        : Container(
                            child: Center(
                              child: Text(
                                "You have no favourites",
                                style: TextStyle(
                                    color: Color.fromRGBO(160, 160, 160, 1)),
                              ),
                            ),
                          );
                  }),
            ),
          );
        },
      ),
    );
  }
}

class FavouriteListTile extends StatelessWidget {
  final ProductModel productModel;
  final int index;
  final User user;
  FavouriteListTile({this.productModel, this.index, this.user});

  final ProductService _productService = new ProductService();
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 160),
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          // color: Colors.blueAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 130,
                  width: computeDimensions(35, constraints.maxWidth),
                  child: Image.network(
                    productModel.productPhotos[0],
                    fit: BoxFit.cover,
                  )),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        productModel.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(100, 100, 100, 1)),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                              "${computePrice(productModel.productDiscount, productModel.productPrice)} GHS",
                              style: TextStyle(
                                color: Color.fromRGBO(30, 201, 180, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        productModel.productDiscount.toInt() != 0
                            ? Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: Text(
                                  "${f.format(productModel.productPrice)} GHS",
                                  style: TextStyle(
                                      // fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(232, 74, 91, 0.5),
                                      decoration: TextDecoration.lineThrough),
                                ),
                              )
                            : Container()
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: productModel.productQuantity <= 0
                              ? Badge(
                                  elevation: 0,
                                  badgeColor: Colors.white,
                                  shape: BadgeShape.square,
                                  borderRadius: 20,
                                  padding: EdgeInsets.all(4),
                                  toAnimate: false,
                                  badgeContent: Text("Out of Stock",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(249, 109, 128, 1),
                                          fontWeight: FontWeight.bold)),
                                )
                              : Badge(
                                  elevation: 0,
                                  badgeColor: Color.fromRGBO(0, 188, 212, 1),
                                  shape: BadgeShape.square,
                                  borderRadius: 20,
                                  toAnimate: false,
                                  badgeContent: Text(
                                      "In Stock: ${productModel.productQuantity}",
                                      style: TextStyle(color: Colors.white)),
                                ),
                        ),
                        IconButton(
                          onPressed: () {
                            _productService.favoriteProductHandler(
                                user.uid, productModel.productRef);
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
