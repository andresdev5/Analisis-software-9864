import 'dart:convert';
import 'package:eco_adventure/config.dart';
import 'package:eco_adventure/presentation/models/destination_model.dart';
import 'package:eco_adventure/presentation/models/review_model.dart';
import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

class DestinationService {
  AuthProvider authProvider;

  DestinationService({required this.authProvider});

  Future<Destination> getDestination(int id) async {
    final response = await http.get(Uri.parse('${Config.apiURL}/destination/$id'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider.token ?? ''}',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] ?? {};
      return Destination.fromJson(data);
    } else {
      throw Exception('Failed to retrieve destination');
    }
  }

  Future<List<Review>> getDestinationReviews(int id) async {
    final response = await http.get(Uri.parse('${Config.apiURL}/destination/$id/reviews'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authProvider.token ?? ''}',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] ?? [];
      return List<Review>.from(data.map((x) => Review.fromJson(x)));
    } else {
      throw Exception('Failed to retrieve destination reviews');
    }
  }
}
