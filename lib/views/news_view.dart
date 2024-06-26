import 'package:flutter/material.dart';
import 'map_view.dart'; // Asegúrate de importar la nueva vista del mapa

class News extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Aquí se muestran las noticias.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapView()),
                );
              },
              child: Text('Reporte de Incidente'),
            ),
          ],
        ),
      ),
    );
  }
}
