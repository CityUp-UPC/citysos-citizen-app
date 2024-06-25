import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


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

  Future<void> _loadLoginStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _token = prefs.getString('token') ?? '';
      _userId = prefs.getInt('userId') ?? 0;

      if (_isLoggedIn && JwtDecoder.isExpired(_token)) {
        await logout();
      }

      notifyListeners();
    } catch (e) {
      print('Error loading login status: $e');
    }
  }

  Future<void> _saveLoginStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', _isLoggedIn);
      await prefs.setString('token', _token);
      await prefs.setInt('userId', _userId);
    } catch (e) {
      print('Error saving login status: $e');
    }
  }

  Future<void> login(String tokenData) async {
    try {
      _isLoggedIn = true;
      _token = tokenData;
      Map<String, dynamic> decodedToken = JwtDecoder.decode(_token);

      if (decodedToken.containsKey('userId')) {
        _userId = decodedToken['userId'];
        await _saveLoginStatus();
        notifyListeners();
      } else {
        throw Exception('Token no válido: falta userId');
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _token = '';
    _userId = 0;
    await _saveLoginStatus();
    notifyListeners();
  }
}
