import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/models/user.dart';
import 'package:e_wallet/rest/StringConfigs.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var facebookLogin = FacebookLogin();

  static final AuthRepository _singleton = new AuthRepository._internal();

  factory AuthRepository() {
    return _singleton;
  }

  AuthRepository._internal();

  bool isSignIn = false;
  GoogleSignIn _googleSignIn = new GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);

  Future<String> signInWithEmail(String email, String password) async {
    UserCredential userCredential = (await _auth.signInWithEmailAndPassword(email: email, password: password));
    print(userCredential.toString());
    var user = userCredential.user;
    await userCredential.user.getIdToken().then((token) {
      print(token.toString());
    });
    return user.uid;
  }

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

  Future<CurrentUser> logInWithFacebook() async {
    CurrentUser currentUser;
    var result = await facebookLogin.logIn(['email']);
    if (result.status == FacebookLoginStatus.loggedIn) {
      try {
        var token = result.accessToken.token;
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(400)&access_token=$token');

        var profile = json.decode(graphResponse.body);
        currentUser = CurrentUser(
            profile["first_name"],
            profile["last_name"],
            profile["email"],
            profile["name"],
            profile["password"],
            profile["picture"]["data"]["url"],
            1);

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
  }

  Future<CurrentUser> logInWithGoogle() async {
    CurrentUser currentUser;
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);



    UserCredential userCredential = (await _auth.signInWithCredential(credential));
    var ceva = await userCredential.user.getIdTokenResult().then((ceva) => print(ceva.token));
    var _user = userCredential.user;
//    userCredential.user.getIdToken().then((token) {
//      print("token is " + token.toString());
//    });
//    await _auth.currentUser.getIdToken().then((token) {
//      print(token.toString());
//    });

    if (_user != null) {
      currentUser = CurrentUser(
          _user.displayName,
          _user.displayName,
          _user.email,
          _user.email,
          "password",
          // ignore: deprecated_member_use
          _user.photoUrl,
          2);
    }

    return currentUser;
  }

  Future<void> googleSignout() async {
    await _auth.signOut().then((onValue) {
      _googleSignIn.signOut();
    });
  }

  Future<CurrentUser> getUserFromServer(String accessToken) async {
    Dio dio = new Dio();
    Response response;

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

    CurrentUser user = CurrentUser.fromJson(response.data);

    return user;
  }

  resetPassword(String email) async {
    Dio dio = new Dio();
    Response response;

    Map<String, dynamic> body = {"email": "$email"};

    try {
      await dio.post(
        "https://live.curs-valutar.xyz/users/password-reset/",
        data: body,
      );
    } catch (exception) {
      if (exception is DioError) {
        print(exception.message);
      }
    }
  }

  changePassword(String oldPass, String newPass, String token, int uid) async {
    Dio dio = new Dio();
    Response response;

    Map<String, dynamic> body = {"email": "$email"};

    try {
      await dio.post(
        "https://live.curs-valutar.xyz/users/password-reset/",
        data: body,
      );
    } catch (exception) {
      if (exception is DioError) {
        print(exception.message);
      }
    }
  }
}
