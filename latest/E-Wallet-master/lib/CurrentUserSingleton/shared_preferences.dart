import 'dart:convert';

import 'package:e_wallet/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static final SharedPreference _singleton = new SharedPreference._internal();

  factory SharedPreference() {
    return _singleton;
  }

  SharedPreference._internal();

  getTokenFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sentToken = prefs.getString('sentToken');
    return sentToken;
  }

  setTokenFlag(var sentToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('sentToken', sentToken);
  }

  setAccessToken(String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', accessToken);
  }

  getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('accessToken');
    return jwt;
  }

  setCurrentUser(CurrentUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('current_user', json.encode(user.toJson()).toString());
  }

  Future<CurrentUser> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get("current_user") != null) {
      String user = prefs.getString('current_user');
      return CurrentUser.fromJson(json.decode(user));
    }
    return null;
  }

  logOutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("current_user");
  }
}
