import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  static final String routeName = "Mapscreen";

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double userLat = 0.0;
  double userLng = 0.0;
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  void getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    if (_locationData != null) {
      setState(() {
        userLat = _locationData.latitude;
        userLng = _locationData.longitude;
      });
      print(userLat.toString());
    }
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Map'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                Navigator.of(context)
                    .pop(userLat.toString() + ',' + userLng.toString());
              },
            )
          ],
        ),
        body: GoogleMap(
          initialCameraPosition:
          CameraPosition(target: LatLng(userLat, userLng), zoom: 18),
          markers: {
            Marker(
                markerId: MarkerId('mq'), position: LatLng(userLat, userLng))
          },
        ) ,
    );
  }
}
