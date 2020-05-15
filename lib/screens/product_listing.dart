import 'package:flutter/material.dart';
import 'package:gh_styles/models/users.dart';
import 'package:provider/provider.dart';


class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    
  
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("Login",style: TextStyle(color: Colors.white),),
          color: Colors.redAccent,
          onPressed: (){
            Navigator.pushNamed(context, '/login');
          },
        ),
      ),
    );
  }
}