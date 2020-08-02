import 'package:badges/badges.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gh_styles/models/cart_model.dart';
import 'package:gh_styles/models/product_model.dart';
import 'package:gh_styles/models/users_auth_model.dart';
import 'package:gh_styles/providers/product_details_provider.dart';
import 'package:gh_styles/services/fetch_cart_service.dart';
import 'package:gh_styles/services/fetch_product_service.dart';
import 'package:gh_styles/services/products_services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class DetailsScreen extends StatefulWidget {
  final ProductModel productModel;
  final String heroID;

  DetailsScreen({Key key, this.productModel, this.heroID}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final ProductService _productService = new ProductService();

  final FetchProductService _fetchProductService = new FetchProductService();
  final FetchCartService _cartService = new FetchCartService();
  NumberFormat f = new NumberFormat("###.0#", "en_US");
  ProductDetailsProvider detailsProvider;
  User user;
  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
    detailsProvider =
        Provider.of<ProductDetailsProvider>(context, listen: false);
    detailsProvider.setProductStockQuantity =
        widget.productModel.productQuantity;
    detailsProvider.setProductRef = widget.productModel.productRef;
    detailsProvider.setUID = user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: detailsProvider.scaffoldKey,
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
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: user == null
                    ? IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () => Navigator.pushNamed(context, '/cart'))
                    : StreamBuilder<List<CartModel>>(
                        stream:
                            _cartService.shoppingCartProductStream(user?.uid),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            print(snapshot.error);
                            return Center(child: Icon(Icons.shopping_cart));
                          }
                          List<CartModel> cartData = snapshot?.data;
                          cartData.removeWhere((value) => value == null);
                          return Center(
                            child: Badge(
                              position:
                                  BadgePosition.topRight(top: 0, right: 3),
                              animationDuration: Duration(milliseconds: 300),
                              animationType: BadgeAnimationType.slide,
                              badgeContent: Text(
                                "${cartData.length}",
                                style: TextStyle(color: Colors.white),
                              ),
                              child: IconButton(
                                  icon: Icon(Icons.shopping_cart),
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/cart')),
                            ),
                          );
                        }),
              )
            ],
          ),
          backgroundColor: Color(0xfff9f9f9),
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return Container(
                height: viewportConstraints.maxHeight,
                width: viewportConstraints.maxWidth,
                child: Column(
                  children: [
                    Container(
                      height:
                          computeDimensions(88, viewportConstraints.maxHeight),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: viewportConstraints.maxWidth,
                              height: computeDimensions(
                                  50, viewportConstraints.maxHeight),
                              child: Hero(
                                tag: '${widget.heroID}',
                                child:
                                    widget.productModel.productPhotos.length > 1
                                        ? Carousel(
                                            indicatorBgPadding: 5.0,
                                            dotSize: 6,
                                            autoplay: true,
                                            dotColor: Colors.black,
                                            dotIncreasedColor: Colors.blue,
                                            dotBgColor: Color(0xfff9f9f9),
                                            images: widget
                                                .productModel.productPhotos
                                                .map(
                                                  (photo) => Image.network(
                                                    "$photo",
                                                    fit: BoxFit.fill,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .7,
                                                  ),
                                                )
                                                .toList(),
                                          )
                                        : Image.network(
                                            "${widget.productModel.productPhotos[0]}",
                                            fit: BoxFit.fill,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .7,
                                          ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "${widget.productModel.productName}",
                                      style: TextStyle(fontSize: 28),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  user == null
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.favorite_border,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            Toast.show(
                                                "Please Login to add favourite",
                                                context,
                                                duration: 3,
                                                gravity: Toast.BOTTOM);
                                          },
                                        )
                                      : StreamBuilder<
                                              List<Stream<ProductModel>>>(
                                          stream: _fetchProductService
                                              .singleFavouriteProductsStream(
                                                  user.uid,
                                                  widget
                                                      .productModel.productRef),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Icon(
                                                Icons.favorite_border,
                                                color: Colors.red,
                                              );
                                            }
                                            int favCount = snapshot.data.length;
                                            return IconButton(
                                              icon: Icon(
                                                favCount <= 0
                                                    ? Icons.favorite_border
                                                    : Icons.favorite,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                _productService
                                                    .favoriteProductHandler(
                                                        user.uid,
                                                        widget.productModel
                                                            .productRef);
                                              },
                                            );
                                          }),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ExpandablePanel(
                                header: Text(
                                  "Description",
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Color.fromRGBO(150, 150, 150, 1)
                                      // fontWeight: FontWeight.bold
                                      ),
                                ),
                                collapsed: Text(
                                  "${widget.productModel.productDescription}",
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16),
                                ),
                                expanded: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${widget.productModel.productDescription}",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                        )),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ProductQuantityCounter(),
                                  Container(
                                    child: Center(
                                      child: Consumer<ProductDetailsProvider>(
                                          builder: (_, data, __) {
                                        return Text(
                                          "${data.computePrice(widget.productModel.productDiscount, widget.productModel.productPrice)} GHS",
                                          style: TextStyle(
                                            fontSize: 20,
                                            // color: Color.fromRGBO(4, 222, 173, 1)
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Badge(
                                      padding: EdgeInsets.all(6),
                                      badgeColor: Colors.white,
                                      borderRadius: 20,
                                      elevation: 0,
                                      shape: BadgeShape.square,
                                      toAnimate: false,
                                      badgeContent:
                                          Consumer<ProductDetailsProvider>(
                                              builder: (_, data, __) {
                                        return data.quantityInStock > 0
                                            ? Text(
                                                "In Stock: ${data.quantityInStock}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1,
                                                    fontSize: 16),
                                              )
                                            : Text(
                                                "Out of Stock",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1,
                                                    color: Colors.redAccent,
                                                    fontSize: 16),
                                              );
                                      })),
                                  widget.productModel.productDiscount.toInt() !=
                                          0
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            "${f.format(widget.productModel.productPrice)} GHS",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color.fromRGBO(
                                                    232, 74, 91, 0.5),
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      height:
                          computeDimensions(12, viewportConstraints.maxHeight),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: ButtonTheme(
                                height: 45,
                                child: RaisedButton(
                                  color: Color.fromRGBO(231, 48, 91, 1),
                                  onPressed: () {
                                    detailsProvider.addToCart(context);
                                  },
                                  child: Text(
                                    "Add to Cart",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Color.fromRGBO(240, 240, 240, 1)))),
                    )
                  ],
                ),
              );
            },
          )),
    );
  }

  double computeDimensions(double percentage, double constraintHeight) {
    return ((percentage / 100) * constraintHeight);
  }
}

class ProductQuantityCounter extends StatefulWidget {
  @override
  _ProductQuantityCounterState createState() => _ProductQuantityCounterState();
}

class _ProductQuantityCounterState extends State<ProductQuantityCounter> {
  ProductDetailsProvider detailsProvider;
  @override
  void initState() {
    super.initState();
    detailsProvider =
        Provider.of<ProductDetailsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsProvider>(builder: (_, data, __) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () =>
                data.quantityInStock > 0 ? data.increaseQuantity() : null,
            child: Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(),
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(width: 15.0),
          data.quantityInStock > 0
              ? Text("${data.quantityCounter}")
              : Text(
                  "0",
                ),
          SizedBox(width: 15.0),
          GestureDetector(
            onTap: () =>
                data.quantityInStock > 0 ? data.decreaseQuantity() : null,
            child: Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(),
              ),
              child: Icon(Icons.remove),
            ),
          ),
        ],
      );
    });
  }
}
