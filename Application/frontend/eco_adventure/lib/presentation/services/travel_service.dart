import 'dart:convert';
import 'dart:developer';

import 'package:eco_adventure/config.dart';
import 'package:eco_adventure/presentation/models/travel_model.dart';
import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

class TravelService {
  final AuthProvider authProvider;

  TravelService({required this.authProvider});

  Future<void> createReview(int travelId, int rating, String comment) async {
    final response = await http.post(Uri.parse('${Config.apiURL}/travel/review/$travelId'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider.token ?? ''}',
    }, body: jsonEncode({
      'rating': rating,
      'content': comment,
    }));

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to create review');
    }
  }

  Future<Travel> getTravel(int travelId) async {
    final response = await http.get(Uri.parse('${Config.apiURL}/travel/t/$travelId'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider.token ?? ''}',
    });

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to retrieve travel');
    }

    try {
      final data = jsonDecode(response.body)['data'] ?? [];
      final result = Travel.fromJson(data);
      log(result.toString());
      return result;
    } catch (exception, stack) {
      log(exception.toString());
      log(stack.toString());
      throw Exception('Failed to retrieve travel');
    }
  }

  Future<List<Travel>> getCompletedTravels() async {
    final response = await http.get(Uri.parse('${Config.apiURL}/travel/completed'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider.token ?? ''}',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] ?? [];
      final result = List<Travel>.from(data.map((x) => Travel.fromJson(x)));
      return result;
    } else {
      throw Exception('Failed to load travels');
    }
  }

  Future<Travel?> getActiveUserTravelByDestination(int destinationId) async {
    final response = await http.get(Uri.parse('${Config.apiURL}/travel/active/$destinationId'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider.token ?? ''}',
    });

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body)['data'] ?? [];
        return Travel.fromJson(data);
      } catch (exception, stack) {
        log(exception.toString());
        log(stack.toString());
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> createTravel(int destinationId) async {
    final response = await http.post(Uri.parse('${Config.apiURL}/travel/'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider.token ?? ''}',
    }, body: jsonEncode({
      'destinationId': destinationId.toString(),
    }));

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to start travel');
    }
  }

  Future<bool> userIsTravelling() async {
    final response = await http.get(Uri.parse('${Config.apiURL}/travel/user-is-travelling'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider.token ?? ''}',
    });

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to start travel');
    }

    return jsonDecode(response.body)['data'] ?? false;
  }

  Future<List<Travel>> getUserTravels() async {
    final response = await http.get(Uri.parse('${Config.apiURL}/travel/my-travels'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider.token ?? ''}',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] ?? [];
      final result = List<Travel>.from(data.map((x) => Travel.fromJson(x)));
      return result;
    } else {
      throw Exception('Failed to load travels');
    }
  }

  Future<void> completeTravel(int travelId) async {
    final response = await http.post(Uri.parse('${Config.apiURL}/travel/complete/$travelId'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider.token ?? ''}',
    });

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to complete travel');
    }
  }
}
