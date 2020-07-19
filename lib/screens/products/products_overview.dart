import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/widgets/product_horizontal_list_container.dart';
import '../../test_data.dart';

class ProductsOverView extends StatefulWidget {
  @override
  _ProductsOverViewState createState() => _ProductsOverViewState();
}

class _ProductsOverViewState extends State<ProductsOverView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "New Arrivals",
          style: Theme.of(context).textTheme.headline6.apply(
                fontWeightDelta: 2,
              ),
        ),
        SizedBox(
          height: 20,
        ),

        ProductHorizontalListContainer(productsList),

////////////////////////////////////// LADIES ////////////////////////////////////////////////////////////

        SizedBox(
          height: 40,
        ),
        Text(
          "Ladies",
          style: Theme.of(context).textTheme.headline6.apply(
                fontWeightDelta: 2,
              ),
        ),
        SizedBox(
          height: 10,
        ),
        ProductHorizontalListContainer(productsList),

        /////////////////////////////////////////// MEN /////////////////////////////////////////////////
        SizedBox(
          height: 40,
        ),
        Text(
          "Mens'",
          style: Theme.of(context).textTheme.headline6.apply(
                fontWeightDelta: 2,
              ),
        ),
        SizedBox(
          height: 10,
        ),
        ProductHorizontalListContainer(productsList),

        /////////////////////////////////////////// Kids /////////////////////////////////////////////////
        SizedBox(
          height: 40,
        ),
        Text(
          "Kids'",
          style: Theme.of(context).textTheme.headline6.apply(
                fontWeightDelta: 2,
              ),
        ),
        SizedBox(
          height: 10,
        ),
        ProductHorizontalListContainer(productsList),

        /////////////////////////////////////////// Footwears /////////////////////////////////////////////////
        SizedBox(
          height: 40,
        ),
        Text(
          "Footwears",
          style: Theme.of(context).textTheme.headline6.apply(
                fontWeightDelta: 2,
              ),
        ),
        SizedBox(
          height: 10,
        ),
        ProductHorizontalListContainer(productsList)
      ],
    );
  }
}
