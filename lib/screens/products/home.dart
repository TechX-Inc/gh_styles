import 'package:flutter/material.dart';
import 'package:gh_styles/models/users.dart';
import 'package:gh_styles/screens/products/widgets/categorycontainer.dart';
import 'package:gh_styles/screens/products/widgets/productcontainer.dart';
import 'package:gh_styles/authentication/auth_service.dart';
import 'package:provider/provider.dart';
import '../../test_data.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    return Scaffold(
      backgroundColor: Color(0xfff9f9f9),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blueAccent,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.title),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: Text("Gift"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("Favorite"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text("Person"),
          ),
        ],
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black54),
        backgroundColor: Color(0xfff9f9f9),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            child: ButtonTheme(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: user == null ? OutlineButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                shape: StadiumBorder(),
                child: Text("Sign In",),
                borderSide: BorderSide(color: Colors.black),
              ):OutlineButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  _auth.signOut();
                },
                shape: StadiumBorder(),
                child: Text("Sign Out",),
                borderSide: BorderSide(color: Colors.black),
              )
            ),
          ),


          IconButton(
            icon: Icon(Icons.shopping_basket),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
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
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 81,
              child: CategoryContainer(),
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
      ),
    );
  }
}
