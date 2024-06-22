import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../config/location_permission_service.dart';
import '../components/google_maps_widget.dart';
import '../navbar.dart';
import 'package:intl/intl.dart';

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
  final LocationPermissionService _locationPermissionService = LocationPermissionService();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(widget.incident['date']));

    String status = widget.incident['status'];

    if (status == 'PENDIENT') {
      status = 'Buscando ayuda';
    }
    if (status == 'IN_PROGRESS' || status == 'HELP_REQUIRED') {
      status = 'Policias en camino';
    }
    if (status == 'COMPLETED') {
      status = 'Resuelto';
    }

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
                        formattedDate,
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
                        status,
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
          Container(
            height: 200, // You can adjust the height as needed
            color: Colors.white,
            child: Center(
              child: latitude == null || longitude == null
                  ? CircularProgressIndicator()
                  : GoogleMapsWidget(
                latitude: latitude!,
                longitude: longitude!,
                height: 200, // This height should match the container height
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (widget.incident['police'] == null || widget.incident['police'].isEmpty) ... [
                  Text(
                    'Esperando respuesta de policía',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  CircularProgressIndicator(),
                ]
                else ... [
                  Text(
                    'Policias en camino',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Column(
                        children: widget.incident['police'].map<Widget>((police) {
                          String firstName = police['user']['firstName'] ?? 'N/A';
                          String lastName = police['user']['lastName'] ?? 'N/A';
                          String policeIdentifier = police['policeIdentifier'] ?? 'N/A';

                          return ListTile(
                            leading: Icon(Icons.person),
                            title: Text(firstName + ' ' + lastName),
                            subtitle: Text(policeIdentifier),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> isLocationPermissionGranted() {
    return _locationPermissionService.isLocationPermissionGranted();
  }

  Future<void> _requestLocationPermission() async {
    var permission = await _locationPermissionService.requestLocationPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('Location permissions not granted');
    } else {
      print('Location permissions granted');
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    Position? position = await _locationPermissionService.getCurrentLocation();
    if (position != null && mounted) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    }
  }

  @override
  void dispose() {
    // Cancel any ongoing tasks or subscriptions here
    super.dispose();
  }
}
