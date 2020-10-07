import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageItem extends StatelessWidget {
  final String message;
  final String userName;
  String userImage;
  bool isOwner = false;

  MessageItem(this.message, this.isOwner, this.userName, this.userImage);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
            isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                color: isOwner ? Colors.redAccent : Colors.grey,
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(8),
            child: message.contains("https://")
                ? CachedNetworkImage(imageUrl: message,width: 80,height: 80,)
                : Text(
                    message,
                    softWrap: true,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
