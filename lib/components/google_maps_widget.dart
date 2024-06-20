import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapsWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double height;

  const GoogleMapsWidget({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.height,
  }) : super(key: key);

  @override
  _GoogleMapsWidgetState createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    LatLng targetLocation = LatLng(widget.latitude, widget.longitude);

    return
      GestureDetector(
        onDoubleTap: () {
          _launchGoogleMaps();
        },
        child: Container(
          height: widget.height,
          child: GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: targetLocation,
              zoom: 12,
            ),
            markers: {
              Marker(
                markerId: MarkerId('incident_location'),
                position: targetLocation,
              ),
            },
          ),
        ),
      );
  }

  _launchGoogleMaps() async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}