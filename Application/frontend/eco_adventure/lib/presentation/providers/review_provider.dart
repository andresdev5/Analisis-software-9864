import 'dart:convert';
import 'dart:developer';

import 'package:eco_adventure/config.dart';
import 'package:eco_adventure/presentation/models/review_model.dart';
import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReviewProvider extends ChangeNotifier {
  final AuthProvider? authProvider;
  List<Review> _reviews = [];

  List<Review> get reviews => _reviews;

  ReviewProvider({
    this.authProvider,
  });

  Future<List<Review>> getReviews({bool notify = true}) async {
    final response = await http.get(Uri.parse('${Config.apiURL}/destination/reviews'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider?.token ?? ''}',
    });

    var data = jsonDecode(response.body)['data'] ?? [];

    log(data.toString());

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Something went wrong');
    }

    _reviews.clear();
    final items = List<Review>.from(data.map((x) => Review.fromJson(x)));
    _reviews.addAll(items);

    if (notify) {
      notifyListeners();
    }

    return _reviews;
  }
}
