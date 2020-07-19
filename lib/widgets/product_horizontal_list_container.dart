import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/screens/products/product_details.dart';
import 'package:gh_styles/test_data.dart';

class ProductHorizontalListContainer extends StatefulWidget {
  final List<Product> productsList;
  ProductHorizontalListContainer(this.productsList);

  @override
  _ProductHorizontalListContainerState createState() =>
      _ProductHorizontalListContainerState();
}

class _ProductHorizontalListContainerState
    extends State<ProductHorizontalListContainer> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 35.0,
        maxHeight: 160.0,
      ),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: widget.productsList.length,
          itemBuilder: (context, int index) {
            return Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsScreen(id: index)),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 35.0,
                      maxWidth: 160.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${widget.productsList[index].price}",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    color: Color.fromRGBO(34, 40, 49, 1),
                                    fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Hero(
                              tag: '$index',
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      "${widget.productsList[index].img}",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Badge(
                                      badgeColor:
                                          Color.fromRGBO(148, 15, 55, 1),
                                      // badgeColor: Color.fromRGBO(231, 48, 91, 1),
                                      shape: BadgeShape.square,
                                      borderRadius: 20,
                                      toAnimate: false,
                                      badgeContent: Text('-20%',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          // alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10.0),
                          width: double.infinity,
                          child: Text(
                            "${widget.productsList[index].title}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: Colors.black, fontSize: 17),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                )
              ],
            );
          }),
    );
  }
}
