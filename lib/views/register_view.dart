import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../api/auth_service.dart';
import 'login_view.dart';

void main() => runApp(const TextFieldExampleApp());

class TextFieldExampleApp extends StatelessWidget {
  const TextFieldExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Register(),
    );
  }
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late List<TextEditingController> _controllers;
  String? _selectedDistrict;
  String? _deviceToken;
  final List<String> districts = ['San Isidro', 'Pueblo Libre', 'Jesus Maria', 'San Miguel'];

  AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(7, (_) => TextEditingController()); // Increased to 7 for username
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    _deviceToken = await messaging.getToken();
    print("Device Token: $_deviceToken");
  }

  @override
  void dispose() {
    for (var con in _controllers) {
      con.dispose();
    }
    super.dispose();
  }

  Future<void> _register() async {
    final String username = _controllers[0].text.trim();
    final String firstName = _controllers[1].text.trim();
    final String lastName = _controllers[2].text.trim();
    final String phoneNumber = _controllers[3].text.trim();
    final String dni = _controllers[4].text.trim();
    final String email = _controllers[5].text.trim();
    final String password = _controllers[6].text;

    if (_selectedDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona un distrito')),
      );
      return;
    }

    try {
      final response = await _authService.register(
        username,
        firstName,
        lastName,
        email,
        password,
        phoneNumber,
        dni,
        _deviceToken ?? 'no-device-token',
        _selectedDistrict!,
      );

      if (response.statusCode == 200) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );

        // Navigate to login screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      // Exception occurred during registration
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to register. Please try again later.')),
      );
      print('Error during registration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Registro Ciudadano',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            UserInputField(controller: _controllers[0], hint: 'Username (para iniciar sesión)'),
            const SizedBox(height: 10),
            UserInputField(controller: _controllers[1], hint: 'Nombre'),
            const SizedBox(height: 10),
            UserInputField(controller: _controllers[2], hint: 'Apellido'),
            const SizedBox(height: 10),
            UserInputField(controller: _controllers[3], hint: 'Celular'),
            const SizedBox(height: 10),
            UserInputField(controller: _controllers[4], hint: 'DNI'),
            const SizedBox(height: 10),
            UserInputField(controller: _controllers[5], hint: 'Correo'),
            const SizedBox(height: 10),
            UserInputField(controller: _controllers[6], hint: 'Contraseña', obscureText: true),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Selecciona un distrito',
              ),
              value: _selectedDistrict,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDistrict = newValue;
                });
              },
              items: districts.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return 'Por favor, selecciona un distrito';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Registrarse'),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('¿Ya tienes cuenta?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;

  const UserInputField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingrese su $hint';
          }
          return null;
        },
      ),
    );
  }
}
