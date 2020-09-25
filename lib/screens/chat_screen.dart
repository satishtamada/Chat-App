import 'package:chat_app/model/user.dart';
import 'package:chat_app/providers/UserDataProvider.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widget/message_footer.dart';
import 'package:chat_app/widget/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static final String routeName = '/chatscreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User user;

  @override
  void initState() {
    user = UserDataProvider.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          child: Row(
            children: <Widget>[
              Hero(
                tag: "222",
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(ProfileScreen.routeName);
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(user.userProfileImage),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(user.userName),
            ],
          ),
        ),
        actions: <Widget>[
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            items: [
              DropdownMenuItem(
                child: Text("Logout"),
                value: 'logout',
              ),
            ],
            onChanged: (value) {
              if (value == 'logout') {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('Logout from device..?'),
                          content: Text(
                              'Are you really want to logout from the device.'),
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
                    UserDataProvider.clearUser();
                    Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
                  }
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(user),
            ),
            MessageFooter()
          ],
        ),
      ),
    );
  }
}
