import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widget/message_footer.dart';
import 'package:chat_app/widget/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static final String routeName = '/chatscreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('chat'),
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
              DropdownMenuItem(
                child: Text("Profile"),
                value: 'profile',
              )
            ],
            onChanged: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
              }else if (value=='profile'){
                Navigator.of(context).pushNamed(ProfileScreen.routeName);
              }
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(),
            ),
            MessageFooter()
          ],
        ),
      ),
    );
  }
}