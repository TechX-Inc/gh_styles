import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/models/users_auth_model.dart';
import 'package:gh_styles/services/fetch_product_service.dart';
import 'package:gh_styles/services/products_services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

double computeDimensions(double percentage, double constraintHeight) {
  return ((percentage / 100) * constraintHeight);
}

final f = new NumberFormat("###.0#", "en_US");

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  User user;
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
          "Wishlist",
          style: TextStyle(color: Color.fromRGBO(0, 188, 212, 1), fontSize: 25),
        ),
      ),
      backgroundColor: Color.fromRGBO(248, 252, 255, 1),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
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
                                return Navigator.of(context)
                                    .pushNamed("/product_details", arguments: {
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
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart,
                                color: Color.fromRGBO(200, 200, 200, 1)),
                            SizedBox(height: 10),
                            Text(
                              "Empty",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(200, 200, 200, 1)),
                            ),
                          ],
                        );
                }),
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
      constraints: BoxConstraints(maxHeight: 165),
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          // color: Colors.blueAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                    Container(
                      child: Text(
                        "${f.format(productModel.productPrice)} GHS",
                        style:
                            TextStyle(color: Color.fromRGBO(50, 219, 198, 1)),
                      ),
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

// Color.fromRGBO(178, 235, 242, 1)
