import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gh_styles/models/user_model.dart';

class UserService {
  CollectionReference users = Firestore.instance.collection("Users");

  String _userID;

  String get userID => _userID;

  set setUserID(String uid) {
    _userID = uid;
    print(_userID);
  }

  Stream<UserModel> get userStream {
    return users
        .document(_userID)
        .snapshots()
        .map((snapshot) => UserModel.fromSnapshot(snapshot));
  }
}
