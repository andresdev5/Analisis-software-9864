import 'dart:developer';

import 'package:eco_adventure/config.dart';
import 'package:eco_adventure/presentation/models/auth_credential.dart';
import 'package:eco_adventure/presentation/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String? _token;
  User? _user;

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      notifyListeners();
      return false;
    }

    _token = token;
    _user = User.fromJson(JwtDecoder.decode(token)['data']);

    notifyListeners();
    return true;
  }

  Future<bool> login(AuthCredential credentials) async {
    final response = await http.post(Uri.parse('${Config.apiURL}/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{
          'username': credentials.username,
          'email': credentials.email,
          'password': credentials.password,
        }));

    log(response.body);
    // set token
    var data = jsonDecode(response.body);
    _token = data['token'];
    _user = User.fromJson(data['user']);

    // save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', data['token']);

    notifyListeners();
    return response.statusCode == 200;
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    // remove from local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<void> register(User user) async {
    final response = await http.post(Uri.parse('${Config.apiURL}/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{
          'username': user.username,
          'email': user.email,
          'password': user.password,
        }));

    final json = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(json['message']);
    }

    notifyListeners();
  }

  String? get token {
    return _token;
  }

  User? get user {
    return _user;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
