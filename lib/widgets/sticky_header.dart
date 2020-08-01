import 'package:flutter/material.dart';

class CategoriesHeader extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final List<String> categories;
  CategoriesHeader(this.index, this.selectedIndex, this.categories);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categories[index],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.5,
                color: selectedIndex == index
                    ? Colors.black
                    : Color.fromRGBO(150, 150, 150, 1)),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            height: 2,
            width: 40,
            color: selectedIndex == index ? Colors.orange : Colors.transparent,
          )
        ],
      ),
    );
  }

  // Widget buildCategory(int index) {
  //   return
  // }
}
