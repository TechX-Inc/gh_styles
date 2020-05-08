import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gh_styles/models/users.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _newUser (FirebaseUser user){
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_newUser);
  }




  //sign out
  Future signOut () async{
    try {
     return await _auth.signOut();
    } catch (e) {
      print("Signout error");
    }
  }


}