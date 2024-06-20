import 'dart:convert';
import 'package:citysos_citizen/api/api_url_global.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/auth_provider.dart';

class CitizenService {
  static const String apiUrlGlobal = ApiUrlGlobal.baseUrl;
  static const String baseUrl = '$apiUrlGlobal/api/v1/citizens';

  Future<dynamic> getCitizenById(int citizenId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
          Uri.parse('$baseUrl/$citizenId'),
          headers: {
            'Authorization': 'Bearer $token',
          }
      );

      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load citizen with id $citizenId');
      }
    } catch (e) {
      String token = AuthProvider().getToken;
      throw Exception('Error fetching data: $e $token');
    }
  }

  Future<dynamic> getCitizenByUserId(int userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
          Uri.parse('$baseUrl/user/$userId'),
          headers: {
            'Authorization': 'Bearer $token',
          }
      );

      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load user with id $userId. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}