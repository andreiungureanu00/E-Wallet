import 'dart:convert';

import 'package:e_wallet/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static final SharedPreference _singleton = new SharedPreference._internal();

  factory SharedPreference() {
    return _singleton;
  }

  SharedPreference._internal();

  setAccessToken(String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', accessToken);
  }

  Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('accessToken');
    return jwt;
  }

  setCurrentUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('current_user', user.toJson().toString());
  }

  Future<User> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get("current_user") != null) {
      return User.fromJson(jsonDecode(prefs.getString('current_user')));
    }
    return null;
  }
}
