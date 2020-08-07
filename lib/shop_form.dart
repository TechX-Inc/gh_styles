import 'package:flutter/material.dart';

double computeDimensions(double percentage, double constraintHeight) {
  return ((percentage / 100) * constraintHeight);
}

class ShopFormNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 252, 255, 1),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              "https://upload.wikimedia.org/wikipedia/commons/0/09/Dummy_flag.png"),
                        ),
                      ),
                      Text(
                        "Register Business",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    style: TextStyle(height: 2.0),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter a product name eg. pension',
                      hintStyle: TextStyle(fontSize: 16),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(16),
                      // fillColor: colorSearchBg,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    style: TextStyle(height: 2.0),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter a product name eg. pension',
                      hintStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(16),
                      // fillColor: colorSearchBg,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    style: TextStyle(height: 2.0),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter a product name eg. pension',
                      hintStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(16),
                      // fillColor: colorSearchBg,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    style: TextStyle(height: 2.0),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter a product name eg. pension',
                      hintStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(16),
                      // fillColor: colorSearchBg,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    style: TextStyle(height: 2.0),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter a product name eg. pension',
                      hintStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(16),
                      // fillColor: colorSearchBg,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    style: TextStyle(height: 2.0),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter a product name eg. pension',
                      hintStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(16),
                      // fillColor: colorSearchBg,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color.fromRGBO(85, 179, 223, 1),
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
