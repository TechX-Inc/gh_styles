import 'package:flutter/material.dart';
import 'package:gh_styles/auth_and_validation/auth_service.dart';
import 'package:gh_styles/models/shops_model.dart';
import 'package:gh_styles/providers/shop_profile_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class NavDrawer extends StatelessWidget {
  final ShopsModel shopsModel;
  NavDrawer({this.shopsModel});
  final AuthService _auth = new AuthService();
  ShopProfileProvider _shopProfileProvider = new ShopProfileProvider();
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
                    fontSize: 25, color: Color.fromRGBO(132, 140, 207, 1)),
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(shopsModel?.shopLogoPath))),
          ),
          ListTile(
            leading: Icon(Icons.add_circle),
            title: Text('New Product'),
            onTap: () => Navigator.pushNamed(context, "/add_product"),
          ),
          ListTile(
            leading: Icon(Icons.edit_attributes),
            title: Text('Edit Shop'),
            onTap: () => Navigator.of(context).pushNamed("/edit_shop",
                arguments: {"edit_mode": true, "shop_model": shopsModel}),
          ),
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
            onTap: () => showAlertDialog(shopsModel, context),
          ),
        ],
      ),
    );
  }

  showAlertDialog(ShopsModel shopsModel, BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget deleteButton = FlatButton(
      child: Text(
        "Delete",
        style: TextStyle(color: Colors.redAccent),
      ),
      onPressed: () => {
        Navigator.of(context).pop(),
        _shopProfileProvider.deleteShop(
            shopsModel.shopLogoPath, shopsModel.shopRef),
        Navigator.of(context).pop()
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Delete Shop"),
      content: Text(
          "By tapping on Delete, everything about this business will be permanently deleted, do you want to proceed?"),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
