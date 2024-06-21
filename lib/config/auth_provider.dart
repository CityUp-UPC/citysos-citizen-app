import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../api/citizen_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _token = '';
  int _userId = 0;

  bool get isLoggedIn => _isLoggedIn;
  String get getToken => _token;
  int get getUserId => _userId;

  AuthProvider() {
    _loadLoginStatus();
  }

  void _loadLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _token = prefs.getString('token') ?? '';
    _userId = prefs.getInt('userId') ?? 0;
    if (_isLoggedIn) {
      if (JwtDecoder.isExpired(_token)) {
        _isLoggedIn = false;
        _userId = 0;
        _token = '';
        _saveLoginStatus();
      }
    }

    notifyListeners();
  }

  void _saveLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn);
    await prefs.setString('token', _token);
    await prefs.setInt('userId', _userId);
  }

  void login(tokenData) {
    _isLoggedIn = true;
    _token = tokenData;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(_token);
    _userId = decodedToken['userId'];
    _saveLoginStatus();
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _token = '';
    _userId = 0;
    _saveLoginStatus();
    notifyListeners();
  }
}
