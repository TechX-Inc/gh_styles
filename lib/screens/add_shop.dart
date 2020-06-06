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
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              // color: Colors.blue,
              color: Color.fromRGBO(109, 0, 39, 1),
              height: MediaQuery.of(context).size.height * 0.40,
              width: double.infinity,
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: const EdgeInsets.only(top: 0), child: AppLogo())),
            Positioned(top: 140, left: 10, right: 10, child: NewShopForms())
          ],
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: 90.0,
      height: 90.0,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: Icon(
        Icons.business,
        color: Color.fromRGBO(109, 0, 39, 1),
        size: 40.0,
      ),
    );
  }
}

class NewShopForms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewShopFormsWidgetState();
}

class _NewShopFormsWidgetState extends State<NewShopForms> {
  FocusNode myFocusNode = new FocusNode();
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          Card(
            elevation: 0,
            shadowColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
              child: Column(
                children: <Widget>[
                  // Text("New Shop", style: TextStyle(
                  //   fontSize: 25,
                  //   fontWeight: FontWeight.bold
                  // ),),
                  _buildEmailField(),
                  _buildPasswordField(),
                  _buildPasswordField(),
                  _buildPasswordField(),
                  _buildPasswordField(),
                  _buildPasswordField(),
                  SizedBox(height: 40),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Shop Name",
        labelStyle: TextStyle(
            color: myFocusNode.hasFocus
                ? Color.fromRGBO(109, 0, 39, 1)
                : Color.fromRGBO(0, 0, 0, 0.6)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(109, 0, 39, 1)),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Test Name",

        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(109, 0, 39, 1)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      color: Color.fromRGBO(109, 0, 39, 1),
      onPressed: () {},
      child: Text(
        'Create Shop',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
