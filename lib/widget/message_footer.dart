import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageFooter extends StatefulWidget {
  @override
  _MessageFooterState createState() => _MessageFooterState();
}

class _MessageFooterState extends State<MessageFooter> {
  var inputText = "";
  var _inputController = new TextEditingController();

  void _sendMessage() async {
    /**
     * hide key board
     */
    FocusScope.of(context).unfocus();
    var user = await FirebaseAuth.instance.currentUser();
    var userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat').add({
      'text': inputText,
      'createdAt': Timestamp.now(),
      'uid': user.uid,
      'userName': userData.data['userName']
    });
    /**
     * set input text as empty
     */
    setState(() {
      inputText = "";
    });
    /**
     * clear input text
     */
    _inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              maxLines: 1,
              controller: _inputController,
              onChanged: (value) {
                setState(() {
                  inputText = value;
                });
              },
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                ),
                hintText: 'Enter your text',
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: inputText.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
