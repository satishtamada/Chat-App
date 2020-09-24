import 'package:chat_app/widget/message_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
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
                  return MessageItem(
                      document[index]['text'],
                      document[index]['uid'] == userSnapchat.data.uid,
                      document[index]['userName'],
                      document[index]['imageUrl'],);
                });
          },
        );
      },
    );
  }
}
