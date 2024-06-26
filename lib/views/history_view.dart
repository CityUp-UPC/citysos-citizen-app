import 'package:flutter/material.dart';
import 'package:citysos_citizen/api/incident_service.dart';

import '../components/incident_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Map<String, dynamic>>> _futureIncidents;
  final _incidentService = IncidentService();
  final List<Incident>incidents = [];

  @override
  void initState() {
    super.initState();
    _futureIncidents = _incidentService.getIncidents();

  }

  void _refreshIncidents() {
    setState(() {
      _futureIncidents = _incidentService.getIncidents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                // Handle home button pressed
              },
            ),
            const SizedBox(width: 8.0),
            Text(
              'Incidentes pasados',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureIncidents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error cargando casos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se han encontrado incidentes pasados'));
          } else {
            final List<Map<String, dynamic>> completedIncidents = snapshot.data!
                  .where((incident) => incident['status'] == 'COMPLETED')
                  .toList();

            if (completedIncidents.isEmpty) {
              return Center(
                  child: Text('No hay incidentes completados encontrados'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final incident = snapshot.data![index];
                return IncidentCard(
                  id: incident['id'],
                  description: incident['description'],
                  date: incident['date'],
                  address: incident['address'],
                  district: incident['district'],
                  latitude: incident['latitude'],
                  longitude: incident['longitude'],
                  status: incident['status'],
                );
              },
            );
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _refreshIncidents,
        tooltip: 'Actualizar',
        child: Icon(Icons.refresh),
      ),
    );
  }
}