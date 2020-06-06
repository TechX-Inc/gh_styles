import 'package:cloud_firestore/cloud_firestore.dart';

class User {

   final CollectionReference users = Firestore.instance.collection('Users');
   
  final String uid;
  final String email;
  User({this.uid, this.email});
  
  Future saveUser(String uid, String username, String email) async{
    return await users.document(uid).setData({
      'username' : username,
      'email' : email,
      'has_shop' : false,
      'active' : true,
      'date_join' : FieldValue.serverTimestamp()
    });
  }

}