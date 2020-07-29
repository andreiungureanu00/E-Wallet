import 'dart:convert';

import 'package:dio/dio.dart';
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

    var response = await dio.post(urlToken, data: body);

    return response.data["access"].toString();
  }

   void logInWithFacebook(User currentUser) async {
    User currentUser;
    var result = await facebookLogin.logIn(['email']);

    if (result.status == FacebookLoginStatus.loggedIn) {
      try {
//        var facebookLoginResult = await facebookLogin.logIn(['email']);
        var token = result.accessToken.token;
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(400)&access_token=${token}');

        var profile = json.decode(graphResponse.body);

        currentUser = User(
            profile["first_name"],
            profile["last_name"],
            profile["email"],
            profile["name"],
            profile["password"],
            profile["picture"]["data"]["url"]);
      } on PlatformException catch (e) {
        print(e.toString());
      }
    } else if (result.status == FacebookLoginStatus.cancelledByUser) {
      print("CancelledByUser");
    } else if (result.status == FacebookLoginStatus.error) {
      print("Error");
    }

  }

  void logoutFromFacebook() async {
    facebookLogin.logOut();
  }

  void logInWithGoogle(User currentUser) async {
    User currentUser;
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
          _user.email, "", _user.photoUrl);
    }

  }

  Future<void> googleSignout() async {
    await _auth.signOut().then((onValue) {
      _googleSignIn.signOut();
    });
  }
}
