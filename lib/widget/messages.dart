import 'package:chat_app/model/user.dart';
import 'package:chat_app/widget/message_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Messages extends StatelessWidget {
  User user;

  Messages(this.user);

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' day ago';
      } else {
        time = diff.inDays.toString() + ' days ago';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' week ago';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' weeks ago';
      }
    }

    return time;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("chat")
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final document = streamSnapshot.data.documents;
        return FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (ctx, userSnapchat) {
            return ListView.builder(
                reverse: true,
                itemCount: document.length,
                itemBuilder: (ctx, index) {
                  Timestamp t = document[index]['createdAt'];
                  DateTime d = t.toDate();
                  return MessageItem(
                    document[index]['text'],
                    document[index]['uid'] == userSnapchat.data.uid,
                    readTimestamp(t.seconds),
                    user.userProfileImage,
                  );
                });
          },
        );
      },
    );
  }
}
