import 'package:flutter/material.dart';

class ProductQuantityCounter extends StatefulWidget {
  @override
  _ProductQuantityCounterState createState() => _ProductQuantityCounterState();
}

class _ProductQuantityCounterState extends State<ProductQuantityCounter> {
  int _count = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              _count += 1;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(),
            ),
            child: Icon(Icons.add),
          ),
        ),
        SizedBox(width: 15.0),
        Text("$_count"),
        SizedBox(width: 15.0),
        GestureDetector(
          onTap: () {
            setState(() {
              _count -= 1;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(),
            ),
            child: Icon(Icons.remove),
          ),
        ),
      ],
    );
  }
}
