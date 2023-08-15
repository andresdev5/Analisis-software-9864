import 'package:eco_adventure/presentation/models/destination_model.dart';

import 'user_model.dart';

class Review {
  final int? id;
  final String? content;
  final User? user;
  final int? score;
  final Destination? destination;
  final DateTime? createdAt;

  Review({
    this.id,
    this.content,
    this.user,
    this.score,
    this.destination,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'],
        content: json['content'],
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        score: json['score'],
        destination: json['destination'] != null ? Destination.fromJson(json['destination']) : null,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'user': user?.toJson(),
        'score': score,
        'destination': destination?.toJson(),
        'createdAt': createdAt?.toIso8601String(),
      };
}
