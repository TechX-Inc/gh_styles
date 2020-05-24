import 'package:flutter/material.dart';
import 'package:gh_styles/authentication/auth_service.dart';
import 'package:gh_styles/models/users.dart';
import 'package:gh_styles/screens/products/favorites.dart';
import 'package:gh_styles/screens/products/home.dart';
import 'package:gh_styles/screens/add_shop.dart';
import 'package:provider/provider.dart';

class ProductWrap extends StatefulWidget {

  @override
  _ProductWrapState createState() => _ProductWrapState();
}

class _ProductWrapState extends State<ProductWrap> {
  int _selectedIndex = 0;
  final AuthService _auth = new AuthService();
  List<Widget> bottomNavPages = [
    HomeScreen(),
    AddShop(),
    Favorites(),
    Favorites(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xfff9f9f9),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black54),
        backgroundColor: Color(0xfff9f9f9),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            child: ButtonTheme(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: user == null
                    ? OutlineButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        shape: StadiumBorder(),
                        child: Text(
                          "Sign In",
                        ),
                        borderSide: BorderSide(color: Colors.black),
                      )
                    : OutlineButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          _auth.signOut();
                        },
                        shape: StadiumBorder(),
                        child: Text(
                          "Sign Out",
                        ),
                        borderSide: BorderSide(color: Colors.black),
                      )),
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: bottomNavPages.elementAt(_selectedIndex),
      // body: HomeScreen(),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blueAccent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.title),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/add_shop.png", height: 24, width: 24,),
            title: Text("New Shop"),

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("Favorite"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text("Sign In"),
          ),
        ],
      ),
    ));
  }


    void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
