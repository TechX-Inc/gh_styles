import 'package:flutter/material.dart';
import 'package:gh_styles/widgets/product_grid_container.dart';
import 'package:gh_styles/screens/products/products_overview.dart';
import 'package:gh_styles/widgets/page_banner.dart';
import 'package:gh_styles/widgets/sticky_header.dart';
import '../test_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<String> _categories = [
    'Overview',
    'Footwears',
    'Bags',
    'Clothings',
    'Shirts',
    'Shorts'
  ];

  List<Widget> _pages = [
    ProductsOverView(),
    ProductGridContainer(productsList),
    ProductGridContainer(productsList),
    ProductGridContainer(productsList),
    ProductGridContainer(productsList),
    ProductsOverView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 25,
          child: Container(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      child:
                          CategoriesHeader(index, _selectedIndex, _categories),
                    ),
                  );
                }),
          ),
        ),

        //
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PageBanner(),
                SizedBox(
                  height: 10,
                ),
                // ProductGridContainer()
                // ProductsOverView(),
                _pages[_selectedIndex]
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//////////////// MIGHT NEED LATER, DO NOT DELETE ///////////////////////
/////////////////SEARCH BAR/////////////////

// TextField(
//   decoration: InputDecoration(
//     fillColor: Colors.white,
//     filled: true,
//     border: InputBorder.none,
//     prefixIcon: Icon(Icons.search),
//     hintText: "Search",
//   ),
// ),
