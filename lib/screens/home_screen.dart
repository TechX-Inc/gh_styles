import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/models/cart_model.dart';
import 'package:gh_styles/models/users_auth_model.dart';
import 'package:gh_styles/providers/main_app_state_provider.dart';
import 'package:gh_styles/screens/products/bags.dart';
import 'package:gh_styles/screens/products/clothings.dart';
import 'package:gh_styles/screens/products/footwears.dart';
import 'package:gh_styles/screens/products/shirts.dart';
import 'package:gh_styles/screens/products/shorts.dart';
import 'package:gh_styles/services/fetch_cart_service.dart';
import 'package:gh_styles/screens/products/products_overview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MainAppStateProvider homeProvider;
  User user;
  final FetchCartService _cartService = new FetchCartService();
  List<String> _tabPagesText = [
    'Overview',
    'Footwears',
    'Bags',
    'Clothings',
    'Shirts',
    'Shorts'
  ];

  List<Widget> _tabPages = [
    ProductsOverView(),
    Footwears(),
    Bags(),
    Clothings(),
    Shirts(),
    Shorts(),
  ];
  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
    homeProvider = Provider.of<MainAppStateProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabPages.length,
      child: Scaffold(
          // backgroundColor: Color.fromRGBO(247, 250, 255, 1),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            // backgroundColor: Color.fromRGBO(126, 37, 83, 1),
            backgroundColor: Color.fromRGBO(132, 140, 207, 1),
            elevation: 2.0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                print("Searching...");
              },
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: user == null
                    ? ValueListenableBuilder(
                        valueListenable:
                            Hive.box<CartModel>("cartBox").listenable(),
                        builder: (context, Box<CartModel> cartModelBox, _) {
                          return cartModelBox.length == 0
                              ? IconButton(
                                  icon: Icon(Icons.shopping_cart),
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/cart'))
                              : Badge(
                                  position:
                                      BadgePosition.topRight(top: 0, right: 3),
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  animationType: BadgeAnimationType.slide,
                                  badgeContent: Text(
                                    "${cartModelBox.length}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: IconButton(
                                      icon: Icon(Icons.shopping_cart),
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/cart')),
                                );
                        })
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
                            child: cartData.length <= 0
                                ? IconButton(
                                    icon: Icon(Icons.shopping_cart),
                                    onPressed: () =>
                                        Navigator.pushNamed(context, '/cart'))
                                : Badge(
                                    position: BadgePosition.topRight(
                                        top: 0, right: 3),
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    animationType: BadgeAnimationType.slide,
                                    badgeContent: Text(
                                      "${cartData.length}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    child: IconButton(
                                        icon: Icon(Icons.shopping_cart),
                                        onPressed: () => Navigator.pushNamed(
                                            context, '/cart')),
                                  ),
                          );
                        }),
              )
            ],
            bottom: TabBar(
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              indicatorWeight: 3.0,
              isScrollable: true,
              tabs: [
                for (final tab in _tabPagesText)
                  Tab(
                    text: tab,
                  ),
              ],
            ),
          ),
          body: TabBarView(
              children: List.generate(_tabPages.length, (index) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: constraints.maxHeight,
                  child: Consumer<MainAppStateProvider>(builder: (_, data, __) {
                    return SingleChildScrollView(
                      physics: data.scrollEnabled
                          ? BouncingScrollPhysics()
                          : NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[_tabPages[index]],
                        ),
                      ),
                    );
                  }),
                );
              },
            );
          }))),
    );
  }
}

//////////////// MIGHT NEED LATER, DO NOT DELETE ///////////////////////
/////////////////SEARCH BAR/////////////////

// TextField(
//   decoration: InputDecoration(
//     fillColor: Colors.white,
//     filled: true,
//     border: InputBorder.none,
//     prefixIcon: Icon(Icons.search),
//     hintText: "Search",
//   ),
// ),
