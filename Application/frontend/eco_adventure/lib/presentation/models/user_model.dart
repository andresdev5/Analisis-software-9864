import 'package:eco_adventure/presentation/models/role_model.dart';
import 'package:eco_adventure/presentation/models/user_profile.dart';

class User {
  int? id;
  String username;
  String email;
  String? password;
  Role? role;
  UserProfile? profile;

  User({
    this.id,
    required this.username,
    required this.email,
    this.password,
    this.role
  });

  static User? fromJson(data) {
    if (data == null) return null;

    return User(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      role: Role.fromJson(data['role']),
    );
  }
}
