import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:gh_styles/models/users.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = new GoogleSignIn();

  User _newUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_newUser);
  }

  Future register(String email, String password, [String username]) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result?.user;
      return _newUser(user);
    } on PlatformException catch (e) {
      return e;
    }
  }

//GOOGLE AUTHENTICATION
  Future registerWithGoogle() async {
    try {
      GoogleSignInAccount googleUser = await _googleAuth.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final AuthResult result = await _auth.signInWithCredential(credential);
      final FirebaseUser user = result?.user;
      if (user != null) {
        new User().saveUser(user.uid, user.displayName, user.email);
      }
      return _newUser(user);
    } on PlatformException catch (e) {
      print("EXCEPTION FROM FIREBASE ${e.message}");
      return null;
    }
  }

  Future login(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result?.user;
      return user;
    } on PlatformException catch (e) {
      return e.code;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("Signout error");
    }
  }
}
