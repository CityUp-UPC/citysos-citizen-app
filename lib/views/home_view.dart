import 'package:citysos_citizen/api/incident_service.dart';
import 'package:citysos_citizen/components/active_incident_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../components/panic_button_widget.dart';
import '../config/location_permission_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double? latitude;
  double? longitude;
  String? _district;
  String? _address;
  bool _isLoading = false;
  List<dynamic>? _incidents;

  final IncidentService _incidentService = IncidentService();
  final LocationPermissionService _locationPermissionService =
  LocationPermissionService();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _getPendingIncidents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.crisis_alert_rounded,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 8.0),
            Text(
              'Emergencia',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8.0),
          ],
        ),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          if (_address != null)
            AddressWidget(address: _address!),
          if (_address == null)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (_incidents != null && _incidents!.isNotEmpty)
            PendingIncidentsWidget(
              onViewIncidents: () {
                Navigator.pushNamed(context, '/incidents');
              },
            ),
          if (_incidents != null && _incidents!.isNotEmpty)
            ActiveIncidentWidget(
              incident: _incidents![0],
            ),
          if (_incidents == null || _incidents!.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PanicButtonWidget(
                  isLoading: _isLoading,
                  color: Colors.red, icon: Icons.crisis_alert,size: 240,
                  onPressed: () => _handleEmergencyButtonPressed(),
                ),
              ),
            ),
          if (isLocationPermissionGranted() == null ||
              isLocationPermissionGranted() == false)
            LocationPermissionWidget(
              onRequestPermission: () => _requestLocationPermission(),
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
    Position? position =
    await _locationPermissionService.getCurrentLocation();
    if (position != null) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        _getAddressFromLatLng();
      });
    }
  }

  Future<void> _getAddressFromLatLng() async {
    if (latitude != null && longitude != null) {
      Placemark? place = await _locationPermissionService
          .getAddressFromLatLng(latitude!, longitude!);
      if (place != null) {
        setState(() {
          _address =
          "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
          _district = place.subAdministrativeArea;
        });
      }
    }
  }

  Future<void> _getPendingIncidents() async {
    try {
      final List<dynamic> incidents =
      await _incidentService.getPendingIncidentsByCitizenId();
      if (incidents.isNotEmpty) {
        setState(() {
          _incidents = incidents;
        });
      }
    } catch (error) {
      print('Error fetching incidents: $error');
    }
  }

  void _handleEmergencyButtonPressed() {
    _getCurrentLocation();
    if (latitude != null && longitude != null) {
      _createIncident();
    }
  }

  void _createIncident() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _incidentService.createIncident(
        latitude!,
        longitude!,
        _address.toString(),
        _district.toString(),
      );

      if (response != null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Incidente creado'),
              content: const Text(
                  'Se ha creado un incidente en la ubicación actual.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
        _getPendingIncidents();
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(
                'No se pudo crear el incidente. Por favor, inténtelo de nuevo. Error: ${error.toString()}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


class AddressWidget extends StatelessWidget {
  final String address;

  const AddressWidget({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.grey.shade800,
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            address,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class PendingIncidentsWidget extends StatelessWidget {
  final VoidCallback onViewIncidents;

  const PendingIncidentsWidget({
    Key? key,
    required this.onViewIncidents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: Colors.red,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Se ha enviado un incidente a la autoridad local. La entidad encargada está en camino. Por favor, manténgase seguro.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class LocationPermissionWidget extends StatelessWidget {
  final VoidCallback onRequestPermission;

  const LocationPermissionWidget({
    Key? key,
    required this.onRequestPermission,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.grey.shade800,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'La aplicación necesita permisos de ubicación para funcionar correctamente. Por favor, habilite los permisos de ubicación en la configuración de la aplicación.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: onRequestPermission,
              child: Text('Configuración de localización'),
            ),
          ],
        ),
      ),
    );
  }
}