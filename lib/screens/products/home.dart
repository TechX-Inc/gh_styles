import 'package:flutter/material.dart';
import 'package:gh_styles/screens/products/widgets/categorycontainer.dart';
import 'package:gh_styles/screens/products/widgets/productcontainer.dart';
import '../../test_data.dart';
import 'package:sticky_headers/sticky_headers.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Our",
            style: Theme.of(context).textTheme.headline4.apply(
                  fontWeightDelta: 2,
                  color: Colors.black,
                ),
          ),
          Text("Products",
              style:
                  Theme.of(context).textTheme.headline4.copyWith(height: .9)),
          SizedBox(
            height: 15,
          ),
          // TextField(
          //   decoration: InputDecoration(
          //     fillColor: Colors.white,
          //     filled: true,
          //     border: InputBorder.none,
          //     prefixIcon: Icon(Icons.search),
          //     hintText: "Search",
          //   ),
          // ),
          SizedBox(
            height: 15,
          ),
          StickyHeader(
            header: Container(
              height: 30,
              child: CategoryContainer(),
            ),
            content: Container(
              // child: Text("SOME TEST DATA"),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "New Products",
            style: Theme.of(context).textTheme.headline6.apply(
                  fontWeightDelta: 2,
                ),
          ),
          SizedBox(
            height: 11,
          ),
          GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: .7),
            itemCount: productsList.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductContainer(id: index);
            },
          )
        ],
      ),
    );
  }
}
