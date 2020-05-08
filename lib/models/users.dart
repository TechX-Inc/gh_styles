
import 'package:cloud_firestore/cloud_firestore.dart';

class User {

   int join = new DateTime.now().millisecondsSinceEpoch;

  final String uid;
  // final String username;
  final String email;
  User({this.uid, this.email});

  void saveUser(){

  }


}