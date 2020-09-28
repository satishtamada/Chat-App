import 'package:flutter/material.dart';

class User {
  final String userName;
  final String userEmail;
  final String userUid;
  final String userProfileImage;
  User(this.userUid,this.userName, this.userEmail,  this.userProfileImage);

  Map<String, dynamic> toMap() {
    return {
      'userUid': userUid,
      'userName': userName,
      'userEmail': userEmail,
      'userProfileImage': userProfileImage,
    };
  }
}
