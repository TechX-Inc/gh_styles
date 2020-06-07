
import 'package:flutter/material.dart';
import 'package:gh_styles/screens/products/home.dart';

class SearchServices extends SearchDelegate<String>{
  @override
  List<Widget> buildActions(BuildContext context) {
      return [IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){},
      )];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
          close(context, null);
        },
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // TODO: implement buildResults
      return Text("RESULT");
     
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return HomeScreen();
    
  }
  
}