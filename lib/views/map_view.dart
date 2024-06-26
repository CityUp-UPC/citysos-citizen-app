import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../api/incident_service.dart';
import '../components/incident_report_box.dart';
import 'package:intl/intl.dart';


class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController _controller;
  final Location _location = Location();
  final Set<Marker> _markers = {};
  List<Incident> _incidents = [];
  final IncidentService _incidentService = IncidentService();

  @override
  void initState() {
    super.initState();
    _location.onLocationChanged.listen((LocationData currentLocation) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(currentLocation.latitude!, currentLocation.longitude!), zoom: 15),
        ),
      );
      _fetchNearbyIncidents(currentLocation.latitude!, currentLocation.longitude!);
    });
  }

  void _showIncidentDetails(Incident incident) {
    String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.parse(incident.date));
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 240, 238, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            padding: EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Descripción: ${incident.description}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color.fromRGBO(144, 74, 66, 1))),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Text('Fecha: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color.fromRGBO(144, 74, 66, 1))),
                    Expanded(child: Text(formattedDate, style: TextStyle(fontSize: 16.0))),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Text('Dirección: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color.fromRGBO(144, 74, 66, 1))),
                    Expanded(child: Text('${incident.address}', style: TextStyle(fontSize: 16.0))),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Text('Distrito: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color.fromRGBO(144, 74, 66, 1))),
                    Expanded(child: Text('${incident.district}', style: TextStyle(fontSize: 16.0))),
                  ],
                ),
                SizedBox(height: 5.0),
                if(incident.status == 'PENDIENT')
                  Row(
                  children: [
                    Text('Estado: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color.fromRGBO(144, 74, 66, 1))),
                    Text('Pendiente', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),

                if(incident.status == 'IN_PROGRESS')
                  Row(
                  children: [
                    Text('Estado: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color.fromRGBO(144, 74, 66, 1))),
                    Text('En Progreso', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),
                if(incident.status == 'COMPLETED')
                  Row(
                  children: [
                    Text('Estado: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color.fromRGBO(144, 74, 66, 1))),
                    Text('Finalizado', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),
                if(incident.status == 'HELP_REQUIRED')
                  Row(
                  children: [
                    Text('Estado: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color.fromRGBO(144, 74, 66, 1))),
                    Text('Ayuda Requerida', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _fetchNearbyIncidents(double latitude, double longitude) async {
    List<Incident> incidents = await _incidentService.fetchNearIncidents(latitude, longitude, 2);
    setState(() {
      _incidents = incidents;
      _markers.clear();
      for (var incident in incidents) {
        _markers.add(
          Marker(
            markerId: MarkerId(incident.id.toString()),
            position: LatLng(incident.latitude, incident.longitude),
            onTap: () {
              _showIncidentDetails(incident);
            },
          ),
        );
      }
    });
  }

  void _showIncidentStats() {
    int totalIncidents = _incidents.length;
    int pendingIncidents = _incidents.where((incident) => incident.status == 'PENDIENT').length;
    int inProgressIncidents = _incidents.where((incident) => incident.status == 'IN_PROGRESS').length;
    int completedIncidents = _incidents.where((incident) => incident.status == 'COMPLETED').length;
    int helpRequiredIncidents = _incidents.where((incident) => incident.status == 'HELP_REQUIRED').length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.only(right: 15.0, bottom: 10.0),
          backgroundColor: Color.fromRGBO(255, 240, 238, 1),
          title: Text('Estadísticas de Incidentes', style: TextStyle(color: Color.fromRGBO(144, 74, 66, 1)),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
              children: [
                Text('Total de incidentes: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                Expanded(child: Text('$totalIncidents', style: TextStyle(fontSize: 16.0))),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Text('Pendientes: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                Expanded(child: Text('${((pendingIncidents / totalIncidents) * 100).toStringAsFixed(2)}%', style: TextStyle(fontSize: 16.0))),
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                Text('En Progreso: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                Expanded(child: Text('${((inProgressIncidents / totalIncidents) * 100).toStringAsFixed(2)}%', style: TextStyle(fontSize: 16.0))),
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                Text('Completados: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                Expanded(child: Text('${((completedIncidents / totalIncidents) * 100).toStringAsFixed(2)}%', style: TextStyle(fontSize: 16.0))),
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                Text('Ayuda Requerida: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                Expanded(child: Text('${((helpRequiredIncidents / totalIncidents) * 100).toStringAsFixed(2)}%', style: TextStyle(fontSize: 16.0))),
              ],
            ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reporte de Incidentes', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
              zoom: 2,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _location.getLocation().then((locationData) {
                _controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: LatLng(locationData.latitude!, locationData.longitude!), zoom: 15),
                  ),
                );
                _fetchNearbyIncidents(locationData.latitude!, locationData.longitude!);
              });
            },
            myLocationEnabled: true,
          ),
          IncidentReportBox(
            incidentCount: _incidents.length,
            onTap: _showIncidentStats,
          ),
        ],
      ),
    );
  }
}




/* 
                if(incident.status == 'PENDIENT')
                  Row(
                  children: [
                    Text('Estado: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color.fromRGBO(144, 74, 66, 1))),
                    Text('Pendiente', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),

                if(incident.status == 'IN_PROGRESS')
                  Row(
                  children: [
                    Text('Estado: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color.fromRGBO(144, 74, 66, 1))),
                    Text('En Progreso', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),
                if(incident.status == 'COMPLETED')
                  Row(
                  children: [
                    Text('Estado: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color.fromRGBO(144, 74, 66, 1))),
                    Text('Finalizado', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),
                if(incident.status == 'HELP_REQUIRED')
                  Row(
                  children: [
                    Text('Estado: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color.fromRGBO(144, 74, 66, 1))),
                    Text('Ayuda Requerida', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),




 */