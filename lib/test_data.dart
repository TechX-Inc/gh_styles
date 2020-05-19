import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Product {
  final String title, description, price, img;
  Product({this.title, this.description, this.price, this.img});
}

List<Product> productsList = [
  Product(
    description: 'This is an african made beautiful bead necklace',
    title: "African Bead Necklace",
    price: "\₵18.99",
    img: 'assets/images/necklace.jpg',
  ),
  Product(
    description: 'A coloerful african Kente fan',
    title: "Kente Fan",
    price: "\₵5.93",
    img: 'assets/images/fan.jpg',
  ),
  Product(
    description: 'Silver African Ring',
    title: "silver ring",
    price: "\₵6.99",
    img: 'assets/images/ring.jpg',
  ),
  Product(
    description: 'Beautiful African styled dress for ladies',
    title: "Adepa Y3 Dress",
    price: "\₵48.99",
    img: 'assets/images/dress.jpg',
  ),
  Product(
    description: 'Kente sytled ladies\' purse',
    title: "African Purse",
    price: "\₵13.50",
    img: 'assets/images/purse.jpg',
  ),
  Product(
    description: 'African colored round fan',
    title: "Colorful round fan",
    price: "\₵7.50",
    img: 'assets/images/fan2.jpg',
  ),
  Product(
    description: 'African Made gold chain for ladies',
    title: "Gold Necklace",
    price: "\₵44.80",
    img: 'assets/images/chain.jpg',
  ),
  Product(
    description: 'Kente themed press-button dress for babies',
    title: "Kente Baby dress",
    price: "\₵23.00",
    img: 'assets/images/baby.jpg',
  ),
  Product(
    description: 'Kente printed round-neck t-shirt',
    title: "Kente T-shirt",
    price: "\₵20.00",
    img: 'assets/images/tshirt.jpg',
  ),
  Product(
    description: 'Kente sytled royal sandals',
    title: "Ahenemma sandals",
    price: "\₵45.00",
    img: 'assets/images/sandals.jpg',
  ),
];

class Category {
  final String title;
  Category({this.title});
}

List<Category> cats = [
  Category(
    title: "All Products",
  ),
  Category(
    title: "Footwear",
  ),
  Category(
    title: "Bags",
  ),
  Category(
    title: "Accessories",
  ),
  Category(
    title: "Kids",
  ),
  Category(
    title: "Dresses",
  ),
];
