import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AddShop extends StatefulWidget {
  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
List<Widget> _images = [
  Image.asset("assets/images/dress.jpg", fit: BoxFit.cover),
  Image.asset("assets/images/fan.jpg", fit: BoxFit.cover),
  Image.asset("assets/images/ring.jpg", fit: BoxFit.cover),
];


  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.45,
      widthFactor: 1.0,
      child: Container(
          // color: Colors.cyan,
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              viewportFraction: 1.0,
              aspectRatio: 1,
              enlargeCenterPage: true
              ),
            items: [0, 1, 2].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(color: Colors.amber),
                      child: _images[i]
                      );
                },
              );
            }).toList(),
          )),
    );
  }
}
