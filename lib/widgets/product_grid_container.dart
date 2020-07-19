import 'package:flutter/material.dart';
import '../test_data.dart';
import 'package:gh_styles/screens/products/product_details.dart';
import 'package:badges/badges.dart';

class ProductGridContainer extends StatefulWidget {
  final List<Product> productsList;
  const ProductGridContainer(this.productsList, {Key key}) : super(key: key);

  @override
  _ProductGridContainerState createState() => _ProductGridContainerState();
}

class _ProductGridContainerState extends State<ProductGridContainer> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 25,
            childAspectRatio: .7),
        itemCount: widget.productsList.length,
        itemBuilder: (context, int index) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailsScreen(id: index)),
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.productsList[index].price}",
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Color.fromRGBO(34, 40, 49, 1), fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Hero(
                          tag: '$index',
                          child: FractionallySizedBox(
                              widthFactor: 0.9,
                              heightFactor: 1.0,
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
                              ))),
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
          );
        });
  }
}
