import 'package:flutter/material.dart';
import 'package:gh_styles/auth_and_validation/auth_service.dart';
import 'package:gh_styles/models/shops_model.dart';
import 'package:gh_styles/screens/main_screen_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';

class NavDrawer extends StatelessWidget {
  final ShopsModel shopsModel;
  NavDrawer({this.shopsModel});
  final AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              child: Text(
                shopsModel?.shopName,
                style: GoogleFonts.kulimPark(
                    fontSize: 25, color: Color.fromRGBO(77, 8, 154, 1)),
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(shopsModel?.shopLogoPath))),
          ),
          ListTile(
            leading: Icon(Icons.new_releases),
            title: Text('New Product'),
            onTap: () => Navigator.pushNamed(context, "/add_product"),
          ),
          ListTile(
            leading: Icon(Icons.edit_attributes),
            title: Text('Edit Shop'),
            onTap: () => Navigator.of(context).pushNamed("/edit_shop",
                arguments: {"edit_mode": true, "shop_model": shopsModel}),
          ),
          // ListTile(
          //   leading: Icon(Icons.person),
          //   title: Text('Profile'),
          //   onTap: () => {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => MainScreenWrapper(pageIndex: 3),
          //       ),
          //     )
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => _auth.signOut(),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.redAccent),
            title: Text(
              'Delete Business',
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
