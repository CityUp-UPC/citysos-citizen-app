import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressWidget extends StatelessWidget {
  final String address;

  const AddressWidget({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.grey.shade800,
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            address,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}