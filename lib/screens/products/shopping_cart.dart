import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/models/cart_model.dart';
import 'package:gh_styles/models/users_auth_model.dart';
import 'package:gh_styles/providers/cart_provider.dart';
import 'package:gh_styles/services/fetch_cart_service.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:gh_styles/providers/main_app_state_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final CartProvider _cartProvider = new CartProvider();
final f = new NumberFormat("###.0#", "en_US");

double computeDimensions(double percentage, double constraintHeight) {
  return ((percentage / 100) * constraintHeight);
}

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  User user;
  final FetchCartService _cartService = new FetchCartService();
  MainAppStateProvider mainAppStateProvider = new MainAppStateProvider();
  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _cartProvider.scaffoldKey,
        // backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            "My Cart",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Color.fromRGBO(247, 250, 255, 1),
          actions: [
            FlatButton(
                child: Text(
                  "Clear All",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () {
                  user != null
                      ? _cartProvider.removeAllFromCart(user.uid)
                      : _cartProvider.clearHiveCart();
                })
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                  height: computeDimensions(100, constraints.maxHeight),
                  width: constraints.maxWidth,
                  child: ChangeNotifierProvider<CartProvider>(
                      create: (context) => new CartProvider(),
                      builder: (context, data) {
                        return user == null
                            ? ValueListenableBuilder(
                                valueListenable:
                                    Hive.box<CartModel>("cartBox").listenable(),
                                builder:
                                    (context, Box<CartModel> cartModelBox, _) {
                                  return cartModelBox.isNotEmpty
                                      ? Column(
                                          children: [
                                            Container(
                                                height: computeDimensions(
                                                    90, constraints.maxHeight),
                                                child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxHeight:
                                                          double.infinity,
                                                    ),
                                                    child: ListView.builder(
                                                        itemCount: cartModelBox
                                                            .keys
                                                            .toList()
                                                            .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          CartModel cartModel =
                                                              cartModelBox
                                                                  .getAt(index);
                                                          return Dismissible(
                                                              key: UniqueKey(),
                                                              child:
                                                                  CartListTile(
                                                                cartModel:
                                                                    cartModel,
                                                                index: index,
                                                                user: user,
                                                              ),
                                                              onDismissed:
                                                                  (direction) {
                                                                user != null
                                                                    ? _cartProvider.removeCartItem(
                                                                        user
                                                                            .uid,
                                                                        cartModel
                                                                            .productRef,
                                                                        cartModel
                                                                            .orderQuantity)
                                                                    : _cartProvider.removeHiveCartItem(
                                                                        index,
                                                                        cartModel
                                                                            .productID,
                                                                        cartModel
                                                                            .orderQuantity);
                                                              });
                                                        }))),
                                            CartBottomSection(
                                              height: computeDimensions(
                                                  10, constraints.maxHeight),
                                              totalItemsPrice: cartModelBox
                                                  .values
                                                  .toList()
                                                  .fold(
                                                      0,
                                                      (p, c) =>
                                                          p + c.selectionPrice),
                                            )
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.shopping_cart,
                                                color: Color.fromRGBO(
                                                    200, 200, 200, 1)),
                                            SizedBox(height: 10),
                                            Text(
                                              "Empty",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                      200, 200, 200, 1)),
                                            ),
                                          ],
                                        );
                                },
                              )
                            : StreamBuilder<List<CartModel>>(
                                stream: _cartService
                                    .shoppingCartProductStream(user?.uid),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: Text("Loading..."),
                                    );
                                  }
                                  List<CartModel> cartData = snapshot.data;
                                  cartData
                                      .removeWhere((value) => value == null);
                                  return cartData.isNotEmpty
                                      ? Column(
                                          children: [
                                            Container(
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                // color: Colors.blueAccent,
                                                height: computeDimensions(86.5,
                                                    constraints.maxHeight),
                                                child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxHeight:
                                                          double.infinity,
                                                    ),
                                                    child: ListView.builder(
                                                        itemCount:
                                                            cartData.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Dismissible(
                                                              key: ValueKey(
                                                                  "${index}_CART"),
                                                              child:
                                                                  CartListTile(
                                                                cartModel:
                                                                    cartData[
                                                                        index],
                                                                index: index,
                                                                user: user,
                                                              ),
                                                              onDismissed: (direction) => _cartProvider.removeCartItem(
                                                                  user.uid,
                                                                  cartData[
                                                                          index]
                                                                      .productRef,
                                                                  cartData[
                                                                          index]
                                                                      .orderQuantity));
                                                        }))),
                                            CartBottomSection(
                                              height: computeDimensions(
                                                  10, constraints.maxHeight),
                                              totalItemsPrice: cartData.fold(
                                                  0,
                                                  (p, c) =>
                                                      p + c.selectionPrice),
                                            )
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.shopping_cart,
                                                color: Color.fromRGBO(
                                                    200, 200, 200, 1)),
                                            SizedBox(height: 10),
                                            Text(
                                              "Your Cart is Empty",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                      200, 200, 200, 1)),
                                            ),
                                            SizedBox(height: 10),
                                            new OutlineButton(
                                                child: new Text(
                                                    "Continue Shopping",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blueAccent)),
                                                onPressed: () => Navigator
                                                    .pushReplacementNamed(
                                                        context,
                                                        "/main_screen_wrapper"),
                                                borderSide: BorderSide(
                                                    color: Colors.blueAccent),
                                                shape:
                                                    new RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                    .circular(
                                                                30.0)))
                                          ],
                                        );
                                });
                      })),
            );
          },
        ),
      ),
    );
  }
}

//////////////////////////////////////////////CART LIST TILE///////////////////////////////////////////////

class CartListTile extends StatelessWidget {
  final CartModel cartModel;
  final int index;
  final User user;
  CartListTile({this.cartModel, this.index, this.user});

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
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/loader_network.gif',
                  image: cartModel.productPhotos[0],
                  fit: BoxFit.cover,
                ),
              ),
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
                        cartModel.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(100, 100, 100, 1)),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Text("${f.format(cartModel.selectionPrice)} GHS",
                          style: TextStyle(
                            color: Color.fromRGBO(30, 201, 180, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Badge(
                            elevation: 0,
                            badgeColor: Color.fromRGBO(255, 69, 122, 1),
                            shape: BadgeShape.square,
                            borderRadius: 20,
                            toAnimate: false,
                            badgeContent: Text(
                                "Quantity: ${cartModel.orderQuantity}",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.redAccent,
                    ),
                    onPressed: () => user != null
                        ? _cartProvider.removeCartItem(user.uid,
                            cartModel.productRef, cartModel.orderQuantity)
                        : _cartProvider.removeHiveCartItem(index,
                            cartModel.productID, cartModel.orderQuantity),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}

//////////////////////////////BOTTOM SECTION/////////////////////////////////
class CartBottomSection extends StatefulWidget {
  final double height;
  final double totalItemsPrice;
  CartBottomSection({this.height, this.totalItemsPrice});
  @override
  _CartBottomSectionState createState() => _CartBottomSectionState();
}

class _CartBottomSectionState extends State<CartBottomSection> {
  CartProvider cartProvider;
  @override
  void initState() {
    super.initState();
    cartProvider = Provider.of<CartProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return Container(
        height: widget.height,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(right: 20),
              child: Center(
                child: Consumer<CartProvider>(builder: (_, data, __) {
                  return Text(
                    "${f.format(widget.totalItemsPrice)} GHS",
                    style: TextStyle(fontSize: 20),
                  );
                }),
              ),
            ),
            Expanded(
              child: Container(
                child: ButtonTheme(
                  height: computeDimensions(90, widget.height),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Color.fromRGBO(254, 52, 110, 1),
                    // color: Color.fromRGBO(231, 48, 91, 1),
                    onPressed: () {
                      print("Checking out...");
                    },
                    child: Text(
                      "Checkout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            // color: Colors.greenAccent,
            border: Border(
                top: BorderSide(color: Color.fromRGBO(250, 250, 250, 1)))),
      );
    });
  }
}
