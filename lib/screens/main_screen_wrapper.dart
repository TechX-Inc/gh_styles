import 'package:flutter/material.dart';
import 'package:gh_styles/models/cart_model.dart';
import 'package:gh_styles/models/users_auth_model.dart';
import 'package:gh_styles/providers/main_app_state_provider.dart';
import 'package:gh_styles/screens/auth_screens/login_signup_toggle.dart';
import 'package:gh_styles/screens/product_favorites.dart';
import 'package:gh_styles/screens/home_screen.dart';
import 'package:gh_styles/screens/shop.dart';
import 'package:gh_styles/screens/user_profile.dart';
import 'package:gh_styles/services/fetch_shop_service.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class MainScreenWrapper extends StatefulWidget {
  @override
  _MainScreenWrapperState createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 0;
  User user;
  // final FetchCartService _cartService = new FetchCartService();
  FetchShopService fetchShopService = new FetchShopService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      user = Provider.of<User>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<Box<CartModel>>(
            future: Hive.openBox("cartBox"),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Image.asset('assets/images/gh_style.png'),
                );
              }
              return bottomNavPages.elementAt(_selectedIndex);
            }),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Color.fromRGBO(126, 37, 83, 1),
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
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> bottomNavPages = [
    HomeScreen(),
    Consumer<User>(
      builder: (context, user, child) {
        return user == null ? ToggleLoginSignUp() : Shop();
      },
    ),
    Consumer<User>(
      builder: (context, user, child) {
        return Favorites();
      },
    ),
    Consumer<User>(
      builder: (context, user, child) {
        return user == null ? ToggleLoginSignUp() : UserProfile();
      },
    )
  ];
}
