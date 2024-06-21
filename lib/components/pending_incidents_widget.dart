import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PendingIncidentsWidget extends StatelessWidget {
  final VoidCallback onViewIncidents;

  const PendingIncidentsWidget({
    Key? key,
    required this.onViewIncidents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
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
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: onViewIncidents,
              child: const Text('Ver incidentes'),
            ),
          ],
        ),
      ),
    );
  }
}
