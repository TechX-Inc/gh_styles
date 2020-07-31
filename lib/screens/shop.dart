import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gh_styles/models/shops_model.dart';
import 'package:gh_styles/models/users_auth_model.dart';
import 'package:gh_styles/providers/shop_profile_provider.dart';
import 'package:gh_styles/screens/add_shop.dart';
import 'package:gh_styles/screens/shop_profile.dart';
import 'package:gh_styles/services/fetch_shop_service.dart';
import 'package:provider/provider.dart';

class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  User user;
  FetchShopService fetchShopService = new FetchShopService();
  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
    fetchShopService.setUid = user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ShopsModel>>(
        stream: fetchShopService.shopsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: SpinKitSpinningCircle(
              color: Color.fromRGBO(148, 15, 55, 1),
              size: 40.0,
            ));
          } else
            return (snapshot.data == null ||
                    snapshot.data.contains(null) ||
                    snapshot.data.isEmpty)
                ? AddShop()
                : ChangeNotifierProvider<ShopProfileProvider>(
                    create: (context) => new ShopProfileProvider(),
                    builder: (context, data) {
                      return ShopProfile(shopModel: snapshot.data);
                    });
        });
  }
}
