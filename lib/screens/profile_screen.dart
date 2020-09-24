import 'dart:io';

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

  Future getImage() async {
    print('che');
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 100,
              child:_image!=null? Image.file(_image):Text(''),
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
            Text('SATISH KUMAR'),
            Text('SATISH@Gmai.com')
          ],
        ),
      ),
    );
  }
}
