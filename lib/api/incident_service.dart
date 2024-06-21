import 'dart:convert';
import 'dart:ffi';
import 'package:citysos_citizen/api/api_url_global.dart';
import 'package:citysos_citizen/api/citizen_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/auth_provider.dart';

class IncidentService {
  static const String apiUrlGlobal = ApiUrlGlobal.baseUrl;
  static const String baseUrl = '$apiUrlGlobal/api/v1/incidents';

  final CitizenService _citizenService = CitizenService();

  Future<dynamic> createIncident(double latitude, double longitude, String address, String district) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      int userId = prefs.getInt('userId') ?? 0;

      int citizenId = await _getCitizenId(userId);

      final response = await http.post(
          Uri.parse(baseUrl),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Set the correct content type
          },
          body: jsonEncode({
            'description': 'Se solicita ayuda',
            'latitude': latitude,
            'longitude': longitude,
            'address': address,
            'district': district,
            'citizenId': citizenId,
          })
      );

      final dynamic jsonData = jsonDecode(response.body);
      return jsonData;

    } catch (e) {
      throw Exception('Error creating incident: $e');
    }
  }

  Future<int> _getCitizenId(int userId) async {
    try {
      final response = await _citizenService.getCitizenByUserId(userId);

      if (response != null) {
        return response['id'];
      } else {
        throw Exception('Failed to fetch citizenId');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<dynamic> getIncidentById(int id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/incidents/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final dynamic jsonData = jsonDecode(response.body);
      // Reverse the list before returning it
      return jsonData.map((data) => {
        'description': data['description'],
        'date': data['date'],
        'address': data['address'],
        'district': data['district'],
        'latitude': double.parse(data['latitude']),
        'longitude': double.parse(data['longitude']),
        'status': data['status'],
      });
    } catch (e) {
      String token = AuthProvider().getToken;
      throw Exception('Error fetching data: $e $token');
    }
  }


  Future<List<Map<String, dynamic>>> getPendingIncidents() async {
    try {
      print('Getting pending incidents');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/pendients'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

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
    } catch (e) {
      String token = AuthProvider().getToken;
      throw Exception('Error fetching data: $e $token');
    }
  }

  Future<List<Map<String, dynamic>>> getPendingIncidentsByCitizenId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      int userId = prefs.getInt('userId') ?? 0;

      int citizenId = await _getCitizenId(userId);

      final response = await http.get(
        Uri.parse('$baseUrl/pending/$citizenId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final List<dynamic> jsonData = jsonDecode(response.body);
      List<Map<String, dynamic>> incidents = jsonData.map((data) =>
      {
        'id': data['id'],
        'description': data['description'],
        'date': data['date'],
        'address': data['address'],
        'district': data['district'],
        'latitude': double.parse(data['latitude']),
        'longitude': double.parse(data['longitude']),
        'status': data['status'],
        'police': data['police'],
      }).toList();

      return incidents.reversed.toList();
    } catch (e) {
      throw Exception('Error fetching pending incidents: $e');
    }
  }

  Future<dynamic> completeIncidentById(int id) async {
    try {
      print('Completing incident with id: $id');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.put(
        Uri.parse('$apiUrlGlobal/api/v1/polices/incident/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 202) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}