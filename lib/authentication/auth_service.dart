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


Future register(String email, String password, String username) async{
  try {
    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user =  result.user;
    new User().saveUser(user.uid, username, user.email);
    return _newUser(user);
  } catch (e) {
    print(e);
    // if (e.code == "ERROR_EMAIL_ALREADY_IN_USE") {
    //   return "emailExist";
    // }
    return null;
  }
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