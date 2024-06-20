import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_url_global.dart';

class AuthService {
  static const String apiUrlGlobal = ApiUrlGlobal.baseUrl;
  static const String baseUrl = '$apiUrlGlobal/api/v1/auth';

  Future<http.Response> login(String username, String password, String deviceToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode({
          'username': username,
          'password': password,
          'deviceToken': deviceToken,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      return response;
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Failed to login');
    }
  }

  Future<http.Response> register (
          String username,
          String firstName,
          String lastName,
          String email,
          String password,
          String phoneNumber,
          String dni,
          String deviceToken,
          String district) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register-user'),
        body: jsonEncode({
          'username': username,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'dni': dni,
          'deviceToken': deviceToken,
          'district': district,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      return response;
    } catch (e) {
      print('Error during register: $e');
      throw Exception('Failed to register');
    }
  }
}