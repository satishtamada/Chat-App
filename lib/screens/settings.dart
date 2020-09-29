import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helpers/db_helper.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/screens/full_image_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'auth_screen.dart';

class SettingsScreen extends StatefulWidget {
  static final String routeName = 'settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User user;

  void getUserData() async {
    final userData = await DBHelper.userList();
    setState(() {
      user = userData[0];
    });
    print("in chat screen");
    print(user.toMap().toString());
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Widget getListItem(String title, String desc, Function function) {
    return ListTile(
      title: Text(title),
      subtitle: Text(desc),
      onTap: function,
    );
  }

  void logout(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Logout from device..?'),
              content: Text('Are you really want to logout from the device.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
                FlatButton(
                  child: Text('No'),
                  onPressed: () => Navigator.of(ctx).pop(false),
                )
              ],
            )).then((onValue) {
      if (onValue) {
        FirebaseAuth.instance.signOut();
        DBHelper.deleteUser();
        /**
         * clear stack screens.
         */
        Navigator.of(context).pushNamedAndRemoveUntil(
            AuthScreen.routeName, (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Hero(
                  tag: '111',
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            FullImagePreviewScreen.routeName,
                            arguments: {'image': user.userProfileImage});
                      },
                      child: ClipOval(
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageUrl: user.userProfileImage,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.userName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(user.userEmail /**/)
                  ],
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey),
          Expanded(
            child: ListView(
              children: <Widget>[
                getListItem("Profile", "view or edit profile", (() {
                  Navigator.of(context).pushNamed(ProfileScreen.routeName);
                })),
                getListItem("Logout", "logout from device", (() {
                  logout(context);
                })),
              ],
            ),
          )
        ],
      ),
    );
  }
}
