import 'package:flutter/material.dart';

class Feeds extends StatelessWidget {
  const Feeds({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feeds View'),
      ),
      body: const Center(
        child: Text(
          'Feeds Content',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}