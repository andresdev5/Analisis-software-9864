import 'package:eco_adventure/config.dart';
import 'package:eco_adventure/presentation/models/user_profile.dart';
import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider with ChangeNotifier {
  AuthProvider? authProvider;

  UserProvider({this.authProvider});

  Future<UserProfile> getProfile() async {
    var response = await http.get(Uri.parse('${Config.apiURL}/user/profile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${authProvider?.token ?? ''}',
        });

    var data = jsonDecode(response.body)['data'];

    if (response.statusCode != 200) throw Exception(data['message']);
    return UserProfile.fromJson(data['profile']);
  }

  Future<void> updateProfile(int userId, UserProfile profile) async {
    var response = await http.put(
      Uri.parse('${Config.apiURL}/user/profile/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${authProvider?.token ?? ''}',
      },
      body: jsonEncode(<String, dynamic>{
        'firstname': profile.firstname,
        'lastname': profile.lastname,
        'avatar': profile.avatar,
        'about': profile.about,
        'phone': profile.phone,
        'birthday': profile.birthday?.toIso8601String(),
        'country': profile.country?.toJson(),
        'city': profile.city?.id,
      }),
    );

    print(response.body);

    var data = jsonDecode(response.body)['data'];

    if (response.statusCode != 200) throw Exception(data['message']);

    notifyListeners();
  }
}
