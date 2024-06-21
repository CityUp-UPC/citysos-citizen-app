import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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