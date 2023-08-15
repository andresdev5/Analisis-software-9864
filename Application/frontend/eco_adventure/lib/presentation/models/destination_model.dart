import 'package:eco_adventure/presentation/models/location_model.dart';

class Destination {
  int? id;
  String? name = "";
  String? description = "";
  double? latitude = 0;
  double? longitude = 0;
  int? altitude = 0;
  String? image;
  City? city;
  double score = 0;
  int totalReviews = 0;

  Destination({
    this.id,
    this.name,
    this.description,
    this.latitude,
    this.longitude,
    this.altitude,
    this.image,
    this.city,
    this.score = 0,
    this.totalReviews = 0,
  });

  static Destination fromJson(data) {
    return Destination(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      altitude: data['altitude'],
      image: data['image'],
      city: data['city'] != null ? City.fromJson(data['city']) : null,
      score: double.tryParse(data['score'] ?? '0.0')!,
      totalReviews: int.tryParse(data['totalReviews'] ?? '0')!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'image': image,
      'city': city?.toJson(),
      'score': score,
      'totalReviews': totalReviews,
    };
  }
}
