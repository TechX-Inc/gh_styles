import 'package:flutter/material.dart';
import '../../../test_data.dart';
import 'package:gh_styles/screens/products/details.dart';

class ProductContainer extends StatelessWidget {
  final int id;

  const ProductContainer({Key key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailsScreen(id: id)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${productsList[id].price}",
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Color.fromRGBO(34, 40, 49, 1),
                    ),
              ),
            ),
            SizedBox(
                // height: 5.0,
                ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Hero(
                    tag: '$id',
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      heightFactor: 1.0,
                      child: Image.asset(
                        "${productsList[id].img}",
                        fit: BoxFit.fill,
                        // width: double.infinity,
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(57, 62, 70, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(9.0),
                ),
              ),
              child: Text(
                "${productsList[id].title}",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
