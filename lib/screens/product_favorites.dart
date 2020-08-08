import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/models/cart_model.dart';
import 'package:gh_styles/models/users_auth_model.dart';
import 'package:provider/provider.dart';

double computeDimensions(double percentage, double constraintHeight) {
  return ((percentage / 100) * constraintHeight);
}

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  User user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 252, 255, 1),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return Container();
              });
        },
      ),
    );
  }
}

// class CartListTile extends StatelessWidget {
//   final CartModel cartModel;
//   final int index;
//   final User user;
//   CartListTile({this.cartModel, this.index, this.user});
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Container(
//           height: 130,
//           child: LayoutBuilder(
//             builder: (context, listTileConstraints) {
//               return Row(
//                 children: [
//                   Container(
//                       height:
//                           computeDimensions(100, listTileConstraints.maxHeight),
//                       width:
//                           computeDimensions(40, listTileConstraints.maxWidth),
//                       child: Image.network(
//                         cartModel.productPhotos[0],
//                         fit: BoxFit.fill,
//                       )),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           child: Text(
//                             cartModel.productName,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 color: Color.fromRGBO(100, 100, 100, 1)),
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Container(
//                           child: Text(
//                             "${f.format(cartModel.selectionPrice)} GHS",
//                             style: TextStyle(
//                                 color: Color.fromRGBO(50, 219, 198, 1)),
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         Container(
//                           child: Badge(
//                             elevation: 0,
//                             badgeColor: Color.fromRGBO(231, 48, 91, 1),
//                             shape: BadgeShape.square,
//                             borderRadius: 20,
//                             toAnimate: false,
//                             badgeContent: Text(
//                                 "Quantity: ${cartModel.orderQuantity}",
//                                 style: TextStyle(color: Colors.white)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           Icons.close,
//                           color: Colors.redAccent,
//                         ),
//                         onPressed: () => user != null
//                             ? _cartProvider.removeCartItem(user.uid,
//                                 cartModel.productRef, cartModel.orderQuantity)
//                             : _cartProvider.removeHiveCartItem(index,
//                                 cartModel.productID, cartModel.orderQuantity),
//                       ),
//                     ],
//                   )
//                 ],
//               );
//             },
//           )),
//     );
//   }
// }
