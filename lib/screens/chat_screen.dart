import 'package:chat_app/helpers/db_helper.dart';
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
  var isChangedDependenices = false;
  var profileImage = "";
  var userName;
  var userId;

  void getUserData() async {
    final userData = await DBHelper.userList();
    setState(() {
      user = userData[0];
    });
    print("in chat screen");
    print(user.toMap().toString());
  }

  @override
  void didChangeDependencies() {
    if (!isChangedDependenices) {
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      userName = args['name'];
      userId = args['id'];
      profileImage = args['image'];
      isChangedDependenices = true;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
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
                    backgroundImage: NetworkImage(profileImage),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(userName),
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
                    DBHelper.deleteUser();
                    Navigator.of(context)
                        .pushReplacementNamed(AuthScreen.routeName);
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
            MessageFooter(user)
          ],
        ),
      ),
    );
  }
}
