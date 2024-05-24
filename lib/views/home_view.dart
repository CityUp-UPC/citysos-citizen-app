import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:citysos_citizen/navbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child:
          ButtonWithText(color: Colors.redAccent, icon: Icons.radio_button_on, label: 'Presiona en caso de emergencia', size: 200),


    ),
        );
  }
}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    required this.size,

  });

  final Color color;
  final IconData icon;
  final String label;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        ElevatedButton(onPressed: () {
          print('apretado');
        }, child: Icon(icon, color: color, size: size,)
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

}
