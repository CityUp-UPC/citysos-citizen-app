import 'dart:async';

import 'package:citysos_citizen/api/incident_service.dart';
import 'package:citysos_citizen/components/active_incident_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../components/address_widget.dart';
import '../components/location_permission_widget.dart';
import '../components/pending_incidents_widget.dart';
import '../config/location_permission_service.dart';
import '../navbar.dart';
import '../components/panic_button_widget.dart';

import '../config/auth_provider.dart';

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
  final LocationPermissionService _locationPermissionService = LocationPermissionService();
  late Timer _timer;

  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
    _authProvider.addListener(_onAuthProviderChange);
    _startPolling();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthProviderChange);
    _timer.cancel();
    super.dispose();
  }

  void _onAuthProviderChange() {
    if (_authProvider.isLoggedIn) {
      _getPendingIncidents();
    }
  }

  void _startPolling() {
    const pollInterval = Duration(seconds: 5);
    _timer = Timer.periodic(pollInterval, (timer) {
      if (_authProvider.isLoggedIn) {
        _getPendingIncidents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emergencia',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
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
          if (_incidents != null && _incidents!.isNotEmpty) ...[
            PendingIncidentsWidget(
              onViewIncidents: () {
                Navigator.pushNamed(context, '/incidents');
              },
            ),
            ActiveIncidentWidget(
              incident: _incidents![0],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navbar.of(context)?.setIndex(1);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                        ),
                        child: const Text('Ver feed de incidente'),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.horizontal,
                        confirmDismiss: (DismissDirection direction) async {
                          bool confirm = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmación"),
                                content: const Text(
                                    "¿Está seguro que desea cancelar este incidente?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
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
                          return confirm;
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
                              padding:
                              EdgeInsets.symmetric(horizontal: 20.0),
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
            ),
          ],
          if (_incidents == null || _incidents!.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PanicButtonWidget(
                  isLoading: _isLoading,
                  color: Colors.red,
                  icon: Icons.crisis_alert,
                  size: 240,
                  onPressed: () => _handleEmergencyButtonPressed(),
                ),
              ),
            ),
          FutureBuilder<bool>(
            future: isLocationPermissionGranted(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || !snapshot.data!) {
                return LocationPermissionWidget(
                  onRequestPermission: () => _requestLocationPermission(),
                );
              }
              return SizedBox.shrink(); // Return an empty widget if permission is granted
            },
          ),
        ],
      ),
    );
  }

  void _cancelIncident() {
    if (_incidents != null && _incidents!.isNotEmpty) {
      int? incidentId = _incidents![0]['id'] as int?;
      _incidentService.completeIncidentById(incidentId as int).then((response) {
        if (response == true) {
          setState(() {
            _incidents = null;
          });
          _getPendingIncidents();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Incidente cancelado'),
                content: const Text('Se ha cancelado el incidente.'),
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
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(
                    'No se pudo cancelar el incidente. Por favor, inténtelo de nuevo.'),
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
        }
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(
                  'No se pudo cancelar el incidente. Por favor, inténtelo de nuevo. Error: ${error.toString()}'),
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
      });
    } else {
      print('incidents is null or empty.');
    }
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
        _getAddressFromLatLng();
      });
    }
  }

  Future<void> _getAddressFromLatLng() async {
    if (latitude != null && longitude != null) {
      List<Placemark> places =
      await placemarkFromCoordinates(latitude!, longitude!);
      if (places.isNotEmpty) {
        Placemark place = places[0];
        setState(() {
          _address =
          "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
          _district = place.subAdministrativeArea;
        });
      }
    }
  }

  void _getPendingIncidents() async {
    if (_authProvider.isLoggedIn) {
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