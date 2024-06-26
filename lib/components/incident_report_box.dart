import 'package:flutter/material.dart';

class IncidentReportBox extends StatelessWidget {
  final int incidentCount;
  final VoidCallback onTap;

  const IncidentReportBox({required this.incidentCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10.0,
      left: 5.0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            'Incidentes encontrados: $incidentCount',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
