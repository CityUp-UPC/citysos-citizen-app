import 'dart:convert';
import 'dart:io';
import 'package:citysos_citizen/api/citizen_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_url_global.dart';

class NewService {
  static const String apiUrlGlobal = ApiUrlGlobal.baseUrl;
  static const String baseUrl = '$apiUrlGlobal/api/v1/news';

  Future<dynamic> getAllNews() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
          Uri.parse(baseUrl),
          headers: {
            'Authorization': 'Bearer $token',
          }
      );

      final List<dynamic> jsonData = jsonDecode(response.body);

      return jsonData.map((data) => {
        'id': data['id'],
        'description': data['description'],
        'date': data['date'],
        'police-name': data['police']['user']['firstName'] + ' ' + data['police']['user']['lastName'],
        'images': data['images'],
        'comments': data['comments'],
      }).toList().reversed.toList();
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}