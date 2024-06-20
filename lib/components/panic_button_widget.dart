import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PanicButtonWidget extends StatelessWidget {
  const PanicButtonWidget({
    Key? key,
    required this.color,
    required this.icon,
    required this.size,
    required this.onPressed,
    required this.isLoading,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final double? size;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 240, // Fixed width for larger button
                height: 240, // Fixed height for larger button
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.red.withOpacity(0.6),
                      Colors.red,
                    ],
                    stops: [0.3, 1],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5),
                      spreadRadius: 8,
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Icon(
                  icon,
                  color: Colors.white,
                  size: size,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              isLoading ? 'SOLICITANDO AYUDA' : 'SOLICITAR AYUDA',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isLoading ? Colors.white : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}