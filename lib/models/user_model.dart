import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  bool active;
  bool hasShop;
  String email;
  String username;
  String dateJoin;

  UserModel(
      {this.active, this.hasShop, this.username, this.email, this.dateJoin});

  factory UserModel.fromSnapshot(DocumentSnapshot user) {
    return UserModel(
      active: user.data['active'],
      hasShop: user.data['has_shop'],
      email: user.data['email'] ?? "",
      username: user.data['username'] ?? "",
      dateJoin: user.data['date_join'] ?? "",
    );
  }
}
