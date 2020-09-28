import 'dart:io';

import 'package:chat_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MessageFooter extends StatefulWidget {
  final User user;

  MessageFooter(this.user);

  @override
  _MessageFooterState createState() => _MessageFooterState();
}

class _MessageFooterState extends State<MessageFooter> {
  var inputText = "";
  var _inputController = new TextEditingController();
  File _image;
  final picker = ImagePicker();

  void _sendMessage() async {
    /**
     * hide key board
     */
    FocusScope.of(context).unfocus();
    Firestore.instance.collection('chat').add({
      'text': inputText,
      'createdAt': Timestamp.now(),
      'uid': widget.user.userUid,
      'userName': widget.user.userName,
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

  void openAttachmentsBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(10), bottom: Radius.circular(10)),
        ),
        builder: (_) {
          return GestureDetector(
            child: Container(
              height: 100.0,
              color: Colors.white,
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      getImage(0);
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      getImage(1);
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.location_searching,
                      size: 40,
                      color: Colors.blue,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
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
    if (type == 0) {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }
    if (pickedFile != null) {
      _cropImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: () {
              openAttachmentsBottomSheet(context);
            },
          ),
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
