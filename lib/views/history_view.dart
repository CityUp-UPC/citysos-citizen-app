
import 'package:citysos_citizen/views/map_view.dart';
import 'package:flutter/material.dart';
import '../api/incident_service.dart';
import '../components/incident_card.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late Future<List<Map<String, dynamic>>> _futureIncidents;
  final _incidentService = IncidentService();

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
                Icons.bar_chart_outlined,
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
              return Center(child: Text('No hay incidentes completados encontrados'));
            }
            return ListView.builder(
              itemCount: completedIncidents.length,
              itemBuilder: (context, index) {
                final incident = completedIncidents[index];
                return IncidentCard(
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
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text('Mapa de calor'),
                      ),
                      body: MapView(), // Replace with your MapView widget
                    ),
                  ),
                );
              },
              child: const Text(
                'Mapa de calor',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          GestureDetector(
            onTap: () {
              _refreshIncidents(); // Refresh incidents
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                Icons.refresh,
                color: Colors.white,
                size: 24.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}