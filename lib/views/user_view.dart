import 'package:citysos_citizen/main.dart';
import 'package:citysos_citizen/views/login_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/auth_provider.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();

  static fromJson(json) {}
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('User'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthWrapper()));
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}

