import 'dart:convert';
import 'package:citysos_citizen/api/api_url_global.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/auth_provider.dart';

class IncidentService {
  static const String apiUrlGlobal = ApiUrlGlobal.baseUrl;
  static const String baseUrl = '$apiUrlGlobal/api/v1/incidents';

  Future<dynamic> createIncident() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'description': 'Test description',
          'latitude': '1.234567',
          'longitude': '1.234567',
          'address': 'Test address',
          'district': 'Test district',
          'citizenId': 1
        })
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        String token = AuthProvider().getToken;
        throw Exception('Failed to load data ${token}');
      }
    } catch (e) {
      String token = AuthProvider().getToken;
      throw Exception('Error fetching data: $e $token');
    }

  }



  Future<List<Map<String, dynamic>>> getPendingIncidents() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/pendients'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        // Reverse the list before returning it
        return jsonData.map((data) => {
          'description': data['description'],
          'date': data['date'],
          'address': data['address'],
          'district': data['district'],
          'latitude': double.parse(data['latitude']),
          'longitude': double.parse(data['longitude']),
          'status': data['status'],
        }).toList().reversed.toList();
      } else {
        String token = AuthProvider().getToken;
        throw Exception('Failed to load data ${token}');
      }
    } catch (e) {
      String token = AuthProvider().getToken;
      throw Exception('Error fetching data: $e $token');
    }
  }
}