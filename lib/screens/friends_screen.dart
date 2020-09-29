import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helpers/db_helper.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth_screen.dart';

class FriendsScreen extends StatefulWidget {
  static final String routeName = 'friends';

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  User user;

  void getUserData() async {
    final userData = await DBHelper.userList();
    setState(() {
      user = userData[0];
    });
    print("in friends screen");
    print(user.toMap().toString());
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void openChat(String userName, String userProfile, BuildContext context) {
    print(userName);
    print(userProfile);
    Navigator.of(context).pushNamed(ChatScreen.routeName,
        arguments: {'id': "id", 'image': userProfile, 'name': userName});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Friends'),
        actions: <Widget>[
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            items: [
              DropdownMenuItem(
                child: Text("Settings"),
                value: 'settings',
              ),
            ],
            onChanged: (value) {
              if (value == 'settings') {
                Navigator.of(context).pushNamed(SettingsScreen.routeName);
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("users").snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final document = streamSnapshot.data.documents;
          return ListView.builder(
              itemCount: document.length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    openChat(document[index]['userName'],
                        document[index]['imageUrl'], context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        ClipOval(
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            imageUrl: document[index]['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(document[index]['userName']),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
