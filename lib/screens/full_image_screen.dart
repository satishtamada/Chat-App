import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullImagePreviewScreen extends StatelessWidget {
  static final String routeName='PreviewScreen';
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as Map<String, String>;
    var imageUrl = args['image'];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Preview'),
      ),
      body: Center(

        child: Hero(
          tag: '111',
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
