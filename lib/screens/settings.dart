import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helpers/db_helper.dart';
import 'package:chat_app/model/user.dart';
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
                ClipOval(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageUrl: user.userProfileImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(user.userName),
                    Text(user.userEmail /**/)
                  ],
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.power_settings_new),
                  label: Text(
                    'Logout',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    logout(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Logout from your device',
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
