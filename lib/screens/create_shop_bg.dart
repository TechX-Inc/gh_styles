import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateShopBg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: constraints.maxWidth,
                    height: computeDimensions(50, constraints.maxHeight),
                    child: Image.asset("assets/images/new_shop_bg.jpg",
                        fit: BoxFit.fill)),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Accelerate Your Business Growth',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 20, letterSpacing: .5),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Reach More People',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 20, letterSpacing: .5),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  alignment: Alignment.center,
                  child: OutlineButton(
                      child: new Text(
                        "Register Shop",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      onPressed: () {},
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double computeDimensions(double percentage, double constraintHeight) {
    return ((percentage / 100) * constraintHeight);
  }
}
