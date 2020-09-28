import 'package:chat_app/helpers/db_helper.dart';
import 'package:chat_app/model/user.dart';
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
    /**
     * check is user available in data base
     */
    final userList = await DBHelper.userList();
    if (userList.length > 0) {
      Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    }
    /*try {
      var user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        var userData = await Firestore.instance
            .collection('users')
            .document(user.uid)
            .get();
        userName = userData['userName'];
        userEmail = userData['userEmail'];
        userUid = user.uid;
        try {
          final ref = FirebaseStorage.instance.ref().child('user_images').child(
              user.uid);
          if (ref != null) {
            var url = await ref.getDownloadURL();
            userProfileImage = url;
          }
        }catch(e){
          print(e);
          print('image downoload');
        }
        UserDataProvider.addUser(userName, userEmail, userUid, userProfileImage);
        if (userData != null)
          Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
        else
          Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      }
    } catch (e) {
      print(e);
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    }*/
    /* User user = new User("111222", "satish", "sat@gmail.com", "profile pic");
    DBHelper.insertUser(user);
    final userList = await DBHelper.userList();
    print(userList.length.toString());*/
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
