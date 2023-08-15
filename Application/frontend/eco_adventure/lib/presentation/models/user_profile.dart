import 'package:eco_adventure/presentation/models/location_model.dart';

class UserProfile {
  final String? firstname;
  final String? lastname;
  final String? avatar;
  final String? about;
  final String? phone;
  final DateTime? birthday;
  final Country? country;
  final City? city;

  UserProfile({
    this.firstname,
    this.lastname,
    this.avatar,
    this.about,
    this.phone,
    this.birthday,
    this.country,
    this.city,
  });

  static UserProfile fromJson(data) {
    return UserProfile(
      firstname: data['firstname'],
      lastname: data['lastname'],
      avatar: data['avatar'],
      about: data['about'],
      phone: data['phone'],
      birthday: data['birthday'] != null ? DateTime.parse(data['birthday']) : null,
      city: data['city'] != null ? City(id: data['city']['id'], name: data['city']['name']) : null,
    );
  }
}
