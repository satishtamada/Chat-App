import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  static final String routeName="Mapscree";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Container(
        child: FlatButton(
          child: Text('Click here'),
          onPressed: () {
            Navigator.of(context).pop('settings');
          },
        ),
      ),
    );
  }
}
