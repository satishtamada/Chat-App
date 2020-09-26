import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  static final String routeName = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _image;
  final picker = ImagePicker();
  String imageUrl = '';
  String userName = "";
  String userEmail = '';
  bool isImageUploading = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera,maxWidth: 100,maxHeight: 100);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void getUserImage() async {
    try {
      var user = await FirebaseAuth.instance.currentUser();
      var userData = await Firestore.instance.collection('users').document(user.uid).get();
      try {
        final ref = FirebaseStorage.instance.ref().child('user_images').child(user.uid);
        var url = await ref.getDownloadURL();
        print(url);
        setState(() {
          imageUrl = url;
        });
      } catch (e) {
        print(e);
      }

      setState(() {
            userName = userData['userName'];
            userEmail = userData['userEmail'];
          });
    } catch (e) {
      print(e);
    }
  }

  @override
  initState() {
    getUserImage();
    super.initState();
  }

  void saveImage() async {
    if (_image != null) {
      setState(() {
        isImageUploading = true;
      });
      var user = await FirebaseAuth.instance.currentUser();
      final ref = FirebaseStorage.instance.ref().child('user_images').child(user.uid);
      await ref.putFile(_image).onComplete;
      var url = await ref.getDownloadURL();
      await Firestore.instance
          .collection('users')
          .document(user.uid)
          .updateData({'imageUrl': url});
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              saveImage();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: "222",
              child: CircleAvatar(
                radius: 100,
                backgroundImage:
                    _image != null ? FileImage(_image) : NetworkImage(imageUrl),
              ),
            ),
            FlatButton.icon(
                onPressed: () {
                  getImage();
                },
                icon: Icon(Icons.camera_alt),
                label: Text('Change profile')),
            SizedBox(
              height: 70,
            ),
            Text(userName),
            Text(userEmail),
            if (isImageUploading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
