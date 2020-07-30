import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/models/user.dart';
import 'package:e_wallet/rest/StringConfigs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String email, password, name, photoUrl;
  var jwt;
  var profile;
  var graphResponse;
  FirebaseUser _user;
  bool isSignInGoogle = false;
  bool isSignInFacebook = false;

  static final AuthRepository _singleton = new AuthRepository._internal();

  factory AuthRepository() {
    return _singleton;
  }

  AuthRepository._internal();

  bool isSignIn = false;
  var facebookLogin = new FacebookLogin();
  GoogleSignIn _googleSignIn = new GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);

  Future<String> login(String username, String password) async {
    Dio dio = new Dio();

    Map<String, dynamic> body = {"username": username, "password": password};

    String urlToken = "${StringConfigs.baseApiUrl}/users/token-obtain/";

    var response = await dio.post(
      urlToken,
      data: body,
    );

    return response.data["access"].toString();
  }

  Future<User> logInWithFacebook() async {
    User currentUser;
    var result = await facebookLogin.logIn(['email']);
    String accessToken;

    if (result.status == FacebookLoginStatus.loggedIn) {
      try {
        var facebookLoginResult = await facebookLogin.logIn(['email']);
//        var token = result.accessToken.token;
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(400)&access_token=${facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);
        print(profile.toString());

        currentUser = User(
            profile["first_name"],
            profile["last_name"],
            profile["email"],
            profile["name"],
            profile["password"],
            profile["picture"]["data"]["url"],
            1);

        accessToken = await AuthRepository().login("testuser", "testuser");
        await CurrentUserSingleton().setAccessTokenAsync(accessToken);
        await CurrentUserSingleton().setCurrentUserAsync(currentUser);
      } on PlatformException catch (e) {
        print(e.toString());
      }
    } else if (result.status == FacebookLoginStatus.cancelledByUser) {
      print("CancelledByUser");
    } else if (result.status == FacebookLoginStatus.error) {
      print("Error");
    }

    return currentUser;
  }

  void logoutFromFacebook() async {
    facebookLogin.logOut();
    await CurrentUserSingleton().logout();
  }

  Future<User> logInWithGoogle() async {
    User currentUser;
    String accessToken;
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    AuthResult result = (await _auth.signInWithCredential(credential));
    _user = result.user;

    if (_user != null) {
      currentUser = User(_user.displayName, _user.displayName, _user.email,
          _user.email, "password", _user.photoUrl, 2);
      accessToken = await AuthRepository().login("testuser", "testuser");
      await CurrentUserSingleton().setAccessTokenAsync(accessToken);
      await CurrentUserSingleton().setCurrentUserAsync(currentUser);
    }

    return currentUser;
  }

  Future<void> googleSignout() async {
    await _auth.signOut().then((onValue) {
      _googleSignIn.signOut();
    });
    await CurrentUserSingleton().logout();
  }

  Future<User> getUserFromServer(String accessToken) async {
    Dio dio = new Dio();
    Response response;
    User currentUser;

    dio.interceptors.add(DioCacheManager(
            CacheConfig(baseUrl: "${StringConfigs.baseApiUrl}/users/profile/"))
        .interceptor);

    response = await dio.get("${StringConfigs.baseApiUrl}/users/profile",
        options: buildCacheOptions(Duration(days: 7),
            maxStale: Duration(days: 10),
            forceRefresh: true,
            options: Options(headers: {
              HttpHeaders.authorizationHeader: "Bearer $accessToken"
            })));

    User user = User.fromJson(response.data);

    return user;
  }

  Future<void> loginWithCredentials(String username, String password) async {
    String accessToken;
    User currentUser;

    accessToken = await AuthRepository()
        .login(username, password);

    await CurrentUserSingleton().setAccessTokenAsync(accessToken);
    currentUser = await AuthRepository().getUserFromServer(accessToken);

    var photoUrl =
        "https://scontent.fkiv4-1.fna.fbcdn.net/v/t1.30497-1/s480x480/84628273_176159830277856_972693363922829312_n.jpg?_nc_cat=1&_nc_sid=12b3be&_nc_ohc=EiCVFZsOtR0AX8bAVby&_nc_ht=scontent.fkiv4-1.fna&_nc_tp=7&oh=4ca52c73ce307020f39f4731f487731d&oe=5F3BA3AA";

    currentUser.photoUrl = photoUrl;
    currentUser.authCode = 3;

    CurrentUserSingleton().setCurrentUserAsync(currentUser);


  }
}
