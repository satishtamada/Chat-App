import 'dart:io';
import 'package:chat_app/helpers/db_helper.dart';
import 'package:chat_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  static final String routeName = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _image;
  final picker = ImagePicker();
  bool isImageUploading = false;
  User user;

  void getUserData() async {
    final userData = await DBHelper.userList();
    setState(() {
      user = userData[0];
    });
    print("in profile screen");
    print(user.toMap().toString());
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<Null> _cropImage(String imagePath) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.pink,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    setState(() {
      if (croppedFile != null) {
        _image = croppedFile;
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImage(int type) async {
    var pickedFile;
    if (type == 1) {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }
    if (pickedFile != null) _cropImage(pickedFile.path);
  }

/*
  void getUserImage() async {
    try {
      var user = await FirebaseAuth.instance.currentUser();
     */
/* var userData =
          await Firestore.instance.collection('users').document(user.uid).get();*/ /*

      try {
        final ref =
            FirebaseStorage.instance.ref().child('user_images').child(user.uid);
        var url = await ref.getDownloadURL();
        print(url);
        setState(() {
          imageUrl = url;
        });
      } catch (e) {
        print(e);
      }

     */
/* setState(() {
        userName = userData['userName'];
        userEmail = userData['userEmail'];
      });*/ /*

    } catch (e) {
      print(e);
    }
  }
*/

  void saveImage() async {
    if (_image != null) {
      setState(() {
        isImageUploading = true;
      });
      var user = await FirebaseAuth.instance.currentUser();
      final ref =
          FirebaseStorage.instance.ref().child('user_images').child(user.uid);
      await ref.putFile(_image).onComplete;
      var url = await ref.getDownloadURL();
      await Firestore.instance
          .collection('users')
          .document(user.uid)
          .updateData({'imageUrl': url});
      Navigator.of(context).pop();
    }
  }

  Future<void> _askedToLead() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Choose your image From'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: const Text('Camera',style: TextStyle(fontSize: 15),),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 2);
                },
                child: const Text('Gallery',style: TextStyle(fontSize: 15),),
              ),
            ],
          );
        })) {
      case 1:
        getImage(1);
        break;
      case 2:
        getImage(2);
        break;
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
            Text(
              user.userName,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 100,
              backgroundImage: _image != null
                  ? FileImage(_image)
                  : NetworkImage(user.userProfileImage),
            ),
            SizedBox(
              height: 30,
            ),
            FlatButton.icon(
                onPressed: () {
                  _askedToLead();
                  //getImage();
                },
                icon: Icon(Icons.camera_alt),
                label: Text('Change profile')),
            SizedBox(
              height: 70,
            ),
            if (isImageUploading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
