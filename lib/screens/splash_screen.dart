import 'package:chat_app/helpers/db_helper.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/friends_screen.dart';
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
      Navigator.of(context).pushReplacementNamed(FriendsScreen.routeName);
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
      backgroundColor: Colors.teal,
      body: Center(
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/chat.png',
              width: 70,
              height: 70,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'ChatApp',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
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
