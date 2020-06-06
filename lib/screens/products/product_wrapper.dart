import 'package:flutter/material.dart';
import 'package:gh_styles/authentication/auth_service.dart';
import 'package:gh_styles/models/users.dart';
import 'package:gh_styles/screens/auth_screens/login_signup_toggle.dart';
import 'package:gh_styles/screens/products/favorites.dart';
import 'package:gh_styles/screens/products/home.dart';
import 'package:gh_styles/screens/add_shop.dart';
import 'package:gh_styles/screens/user_profile.dart';
import 'package:gh_styles/services/search_service.dart';
import 'package:provider/provider.dart';

class ProductWrap extends StatefulWidget {
  @override
  _ProductWrapState createState() => _ProductWrapState();
}

class _ProductWrapState extends State<ProductWrap> {
  int _selectedIndex = 0;
  bool _showAppBar = true;
  final AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    List<Widget> bottomNavPages = [
      HomeScreen(),
      AddShop(),
      Favorites(),
      user == null ? ToggleLoginSignUp() : UserProfile(),
    ];


    print(user);
    return SafeArea(
        child: Scaffold(
      backgroundColor: _selectedIndex == 1 ? Colors.white : Color(0xfff9f9f9),
      appBar: _showAppBar
          ? AppBar(
              iconTheme: IconThemeData(color: Colors.black54),
              backgroundColor: Color(0xfff9f9f9),
              elevation: 0.0,
              leading:  IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 28,
                      ),
                      onPressed: () {
                        showSearch(
                            context: context, delegate: SearchServices());
                      },
                    ),
              actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {},
                      )
                    ,
              ],
            )
          : null,
      body: bottomNavPages.elementAt(_selectedIndex),
      // body: HomeScreen(),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blueAccent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/add_shop.png",
              height: 24,
              width: 24,
            ),
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
      switch (_selectedIndex) {
        case 1:
        case 3:
          setState(() {
            _showAppBar = false;
          });
          break;
        default:
         setState(() {
            _showAppBar = true;
          });
      }
    });
  }
}
