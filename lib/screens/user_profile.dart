import 'package:flutter/material.dart';
import 'package:gh_styles/auth_and_validation/auth_service.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 252, 255, 1),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.person,
                    size: 22,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Account",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                // height: 180,
                child: Card(
                  elevation: 6,
                  color: Color.fromRGBO(242, 246, 255, 1),
                  shadowColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {},
                              iconSize: 16,
                              color: Colors.blueAccent,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "benacq44@gmail.com",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {},
                              iconSize: 16,
                              color: Colors.blueAccent,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Sign Out",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              onTap: () => _auth.signOut(),
                            )
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
                  Icon(Icons.show_chart),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Activities",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                // height: 180,
                child: Card(
                  elevation: 6,
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
                        SizedBox(height: 25),
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
                        SizedBox(height: 25),
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
              SizedBox(height: 30),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.business_center,
                    size: 20,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Shop",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),

              //======================================== SETTINGS =====================================
              SizedBox(height: 10),
              Container(
                // height: 180,
                child: Card(
                  elevation: 6,
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
                                "Sales",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "12",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        SizedBox(height: 25),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              OutlineButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/add_product");
                                },
                                child: Text("New Product"),
                                textColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.blueAccent,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                              ),
                              OutlineButton(
                                onPressed: () {
                                  print("hello");
                                },
                                child: Text("Delete Shop"),
                                textColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(style: BorderStyle.solid),
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
