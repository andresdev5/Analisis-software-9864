import 'dart:developer';

import 'package:eco_adventure/config.dart';
import 'package:eco_adventure/presentation/models/location_model.dart';
import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationProvider with ChangeNotifier {
  AuthProvider? authProvider;

  LocationProvider({this.authProvider});

  Future<List<City>> getAllCities() async {
    var response = await http.get(Uri.parse('${Config.apiURL}/location/cities'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider?.token ?? ''}',
    });

    var data = jsonDecode(response.body)['data'] ?? [];

    if (response.statusCode != 200) throw Exception(data['message']);

    return List<City>.from(data.map((x) => City.fromJson(x)));
  }
}
