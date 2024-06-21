import 'package:citysos_citizen/api/firebase_api.dart';
import 'package:citysos_citizen/firebase_options.dart';
import 'package:citysos_citizen/navbar.dart';
import 'package:citysos_citizen/views/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:citysos_citizen/views/home_view.dart';
import 'package:citysos_citizen/views/feeds_view.dart';
import 'package:citysos_citizen/views/news_view.dart';
import 'package:citysos_citizen/views/user_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'CitySOS Citizen',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return authProvider.isLoggedIn ? const Navbar() : const Login();
  }
}