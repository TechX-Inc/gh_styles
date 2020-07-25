import 'package:flutter/material.dart';
import 'package:gh_styles/models/users_auth_model.dart';
import 'package:gh_styles/providers/HomeScreenStickyHeaderProvider.dart';
import 'package:gh_styles/screens/auth_screens/login_signup_toggle.dart';
import 'package:gh_styles/screens/create_shop_bg.dart';
import 'package:gh_styles/screens/product_favorites.dart';
import 'package:gh_styles/screens/home_screen.dart';
import 'package:gh_styles/screens/add_shop.dart';
import 'package:gh_styles/screens/shop.dart';
import 'package:gh_styles/screens/user_profile.dart';
import 'package:gh_styles/services/search_service.dart';
import 'package:gh_styles/services/user_service.dart';
import 'package:provider/provider.dart';

class MainScreenWrapper extends StatefulWidget {
  @override
  _MainScreenWrapperState createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 0;
  bool _showAppBar = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    List<Widget> bottomNavPages = [
      ChangeNotifierProvider<HomeScreenStickyHeaderProvider>(
          create: (context) => new HomeScreenStickyHeaderProvider(),
          builder: (context, snapshot) {
            return HomeScreen();
          }),
      user == null ? ToggleLoginSignUp() : Shop(),
      Favorites(),
      user == null ? ToggleLoginSignUp() : UserProfile(),
    ];

    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      appBar: _showAppBar
          ? AppBar(
              iconTheme: IconThemeData(color: Colors.black54),
              backgroundColor: Colors.white,
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(
                  Icons.search,
                  size: 28,
                ),
                onPressed: () {
                  print("Searching...");
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {},
                ),
              ],
            )
          : null,
      body: bottomNavPages.elementAt(_selectedIndex),
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
            icon: Icon(Icons.business),
            title: Text("Business"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("Favorites"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text("My Account"),
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
        case 2:
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
