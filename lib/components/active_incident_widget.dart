import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../config/location_permission_service.dart';
import '../components/google_maps_widget.dart';
import '../navbar.dart'; // Import your Navbar widget

class ActiveIncidentWidget extends StatefulWidget {
  final dynamic incident;

  const ActiveIncidentWidget({
    Key? key,
    required this.incident,
  }) : super(key: key);

  @override
  State<ActiveIncidentWidget> createState() => _ActiveIncidentWidgetState();
}

class _ActiveIncidentWidgetState extends State<ActiveIncidentWidget> {
  double? latitude;
  double? longitude;
  final LocationPermissionService _locationPermissionService =
  LocationPermissionService();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.red,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Incidente activo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        '${widget.incident['description']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        '${widget.incident['address']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        '${widget.incident['date']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(
                      Icons.policy,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        '${widget.incident['status']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: latitude == null || longitude == null
                    ? CircularProgressIndicator()
                    : GoogleMapsWidget(
                  latitude: latitude!,
                  longitude: longitude!,
                  height: 200,
                ),
              ),
            ),
          ),
          // Buttons to cancel the incident
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity, // Full width button
                  child: ElevatedButton(
                    onPressed: () {
                      Navbar.navigatorKey.currentState?.setIndex(1);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20.0), // Bigger button
                    ),
                    child: const Text('Ver feed de incidente'),
                  ),
                ),
                const SizedBox(height: 16.0), // Space between buttons
                SizedBox(
                  width: double.infinity, // Full width button
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (DismissDirection direction) async {
                      bool confirm = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmación"),
                            content:
                            const Text("¿Está seguro que desea cancelar este incidente?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  _cancelIncident();
                                },
                                child: Text("Aceptar"),
                              ),
                            ],
                          );
                        },
                      );
                      return confirm; // Return true to dismiss, false to cancel dismiss
                    },
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        _cancelIncident();
                      }
                    },
                    background: Container(
                      color: Colors.redAccent.withOpacity(0.2),
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.redAccent,
                            size: 32.0,
                          ),
                        ),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: const Center(
                        child: Text(
                          'Cancelar incidente',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _cancelIncident() {
    // Perform the cancel incident action
    print("Incident cancelled");
    setState(() {
      // Update UI as needed
    });
  }

  Future<bool> isLocationPermissionGranted() {
    return _locationPermissionService.isLocationPermissionGranted();
  }

  Future<void> _requestLocationPermission() async {
    var permission =
    await _locationPermissionService.requestLocationPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('Location permissions not granted');
    } else {
      print('Location permissions granted');
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    Position? position =
    await _locationPermissionService.getCurrentLocation();
    if (position != null) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    }
  }
}