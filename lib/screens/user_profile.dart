import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gh_styles/auth_and_validation/auth_service.dart';
import 'package:gh_styles/models/shops_model.dart';
import 'package:gh_styles/models/users_auth_model.dart';
import 'package:gh_styles/services/fetch_shop_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FetchShopService fetchShopService = new FetchShopService();
  final AuthService _auth = new AuthService();
  User _user;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<User>(context, listen: false);
    fetchShopService.setUid = _user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(248, 252, 255, 1),
      backgroundColor: Color.fromRGBO(245, 248, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(247, 250, 255, 1),
        actions: [
          InkWell(
            onTap: () => _auth.signOut(),
            child: Container(
              padding: EdgeInsets.only(right: 10, top: 10),
              alignment: Alignment.topRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FaIcon(
                    FontAwesomeIcons.signOutAlt,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.redAccent),
                  )
                ],
              ),
            ),
          )
        ],
        elevation: 0,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.person,
                    size: 25,
                    color: Color.fromRGBO(132, 140, 207, 1),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      "Account",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(132, 140, 207, 1)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                child: Card(
                  elevation: 0,
                  color: Color.fromRGBO(242, 246, 255, 1),
                  shadowColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            "Ben Acq",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "benacq44@gmail.com",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                onTap: () => null)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.show_chart,
                    color: Color.fromRGBO(132, 140, 207, 1),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Activities",
                    style: TextStyle(
                        fontSize: 17,
                        color: Color.fromRGBO(132, 140, 207, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                // height: 180,
                child: Card(
                  elevation: 0,
                  color: Color.fromRGBO(242, 246, 255, 1),
                  shadowColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Purchases",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "12",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Wishlist",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "82",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Cart",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "2",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              StreamBuilder<List<ShopsModel>>(
                  stream: fetchShopService.shopsStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    if ((snapshot.data == null ||
                        snapshot.data.contains(null) ||
                        snapshot.data.isEmpty)) {
                      return Container();
                    } else {
                      return Column(
                        children: [
                          SizedBox(height: 30),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.business_center,
                                size: 25,
                                color: Color.fromRGBO(132, 140, 207, 1),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Shop",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromRGBO(132, 140, 207, 1),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: Card(
                              elevation: 0,
                              color: Color.fromRGBO(242, 246, 255, 1),
                              shadowColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Sales",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            "12",
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Products",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            "82",
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          ButtonTheme(
                                            child: RaisedButton(
                                              elevation: 0,
                                              onPressed: () =>
                                                  Navigator.pushNamed(
                                                      context, "/add_product"),
                                              child: Text(
                                                "New Product",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
/*
shop
Products    45
Sales       324gh
Add Product
Delete Shop
 */
