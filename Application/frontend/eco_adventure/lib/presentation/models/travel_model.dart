import 'package:eco_adventure/presentation/models/destination_model.dart';
import 'package:eco_adventure/presentation/models/user_model.dart';

class Travel {
  int? id;
  Destination? destination;
  User? user;
  DateTime? createdAt;
  DateTime? finishedAt;

  Travel({
    this.id,
    this.destination,
    this.user,
    this.createdAt,
    this.finishedAt,
  });

  Travel copyWith({
    int? id,
    Destination? destination,
    User? user,
    DateTime? createdAt,
    DateTime? finishedAt,
  }) {
    return Travel(
      id: id ?? this.id,
      destination: destination ?? this.destination,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }

  factory Travel.fromJson(Map<String, dynamic> json) => Travel(
        id: json["id"],
        destination: Destination.fromJson(json["destination"]),
        user: User.fromJson(json["user"]),
        createdAt: DateTime.parse(json["createdAt"]),
        finishedAt: json["finishedAt"] == null ? null : DateTime.parse(json["finishedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "destination": destination?.toJson(),
        "user": user?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "finished_at": finishedAt?.toIso8601String(),
      };
}
