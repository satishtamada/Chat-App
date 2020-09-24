import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  final String message;
  final String userName;
  bool isOwner = false;

  MessageItem(this.message, this.isOwner, this.userName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
            isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: isOwner ? Colors.red : Colors.grey,
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(8),
            child: Text(
              message,
              softWrap: true,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              userName,
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
