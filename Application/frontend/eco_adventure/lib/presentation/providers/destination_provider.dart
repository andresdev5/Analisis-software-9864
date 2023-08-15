import 'dart:convert';
import 'dart:developer';

import 'package:eco_adventure/config.dart';
import 'package:eco_adventure/presentation/models/destination_model.dart';
import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DestinationProvider extends ChangeNotifier {
  final AuthProvider? authProvider;
  final _destinations = <Destination>[];
  final _popularDestinations = <Destination>[];
  final _foundDestinations = <Destination>[];
  var _loading = false;

  DestinationProvider({
    this.authProvider,
  });

  List<Destination> get destinations => _destinations;
  List<Destination> get foundDestinations => _foundDestinations;
  List<Destination> get popularDestinations => _popularDestinations;
  bool get loading => _loading;

  Future<List<Destination>> getDestinations({bool notify = true}) async {
    _loading = true;

    final response = await http.get(Uri.parse('${Config.apiURL}/destination/all'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider?.token ?? ''}',
    });

    _loading = false;

    var data = jsonDecode(response.body)['data'] ?? [];

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Something went wrong');
    }

    _destinations.clear();
    final items = List<Destination>.from(data.map((x) => Destination.fromJson(x)));
    _destinations.addAll(items);

    if (notify) {
      notifyListeners();
    }

    return _destinations;
  }

  Future<List<Destination>> getPopularDestinations({bool notify = true}) async {
    _loading = true;

    final response = await http.get(Uri.parse('${Config.apiURL}/destination/popular'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider?.token ?? ''}',
    });

    _loading = false;

    var data = jsonDecode(response.body)['data'] ?? [];

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Something went wrong');
    }

    _popularDestinations.clear();

    for (var item in data) {
      _popularDestinations.add(Destination.fromJson(item));
    }

    if (notify) {
      notifyListeners();
    }

    return _popularDestinations;
  }

  Future<List<Destination>> searchDestinations(String searchValue) async {
    _loading = true;

    final response =
        await http.get(Uri.parse('${Config.apiURL}/destination/search?search=$searchValue'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider?.token ?? ''}',
    });

    _loading = false;

    var data = jsonDecode(response.body)['data'] ?? [];

    log(data.toString());

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Something went wrong');
    }

    _foundDestinations.clear();
    final items = List<Destination>.from(data.map((x) => Destination.fromJson(x)));
    _foundDestinations.addAll(items);
    notifyListeners();

    return _foundDestinations;
  }
}
