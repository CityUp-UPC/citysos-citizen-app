import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _token = '';

  bool get isLoggedIn => _isLoggedIn;
  String get getToken => _token;

  AuthProvider() {
    _loadLoginStatus();
  }

  void _loadLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _token = prefs.getString('token') ?? '';

    if (_isLoggedIn) {
      if (JwtDecoder.isExpired(_token)) {
        _isLoggedIn = false;
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
  }

  void login(tokenData) {
    _isLoggedIn = true;
    _token = tokenData;
    _saveLoginStatus();
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _token = '';
    _saveLoginStatus();
    notifyListeners();
  }
}
