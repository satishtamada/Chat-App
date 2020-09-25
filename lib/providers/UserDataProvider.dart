import 'package:chat_app/model/user.dart';
import 'package:flutter/cupertino.dart';
/*
class User {
  final String userName;
  final String userEmail;
  final String userUid;
  final String userProfileImage;
  User(this.userName, this.userEmail, this.userUid, this.userProfileImage);
}*/

class UserDataProvider {
  static List<User> userData = [];

  static void addUser(
      String userName, String userEmail, String userUid, String userProfile) {
    User user = new User(userName, userEmail, userUid, userProfile);
    userData.clear();
    userData.add(user);
  }

  static User getUser() {
    return userData[0];
  }
  static void clearUser() {
    return userData.clear();
  }

}
