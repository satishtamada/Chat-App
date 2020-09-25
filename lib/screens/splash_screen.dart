import 'package:chat_app/providers/UserDataProvider.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static final String routeName = '/splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = false;
  String userName = "";
  String userEmail = "";
  String userProfileImage = "";
  String userUid = "";

  void checkIsUserLoginStatus() async {
    var user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      final ref =
          FirebaseStorage.instance.ref().child('user_images').child(user.uid);
      var url = await ref.getDownloadURL();
      var userData =
          await Firestore.instance.collection('users').document(user.uid).get();
      userName = userData['userName'];
      userEmail = userData['userEmail'];
      userUid = user.uid;
      userProfileImage = url;
      UserDataProvider.addUser(userName, userEmail, userUid, userProfileImage);
      Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    }
  }

  @override
  void initState() {
    checkIsUserLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.chat_bubble,
              size: 80,
              color: Colors.deepPurpleAccent,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'ChatApp',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 100,
            ),
            CircularProgressIndicator()
          ],
        ),
      )),
    );
  }
}
