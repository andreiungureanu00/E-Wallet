//import 'dart:convert';
//import 'dart:html';
//import 'dart:js';
//
//import 'package:e_wallet/AuthScreen/bloc/login_page_events.dart';
//import 'package:e_wallet/AuthScreen/bloc/login_page_states.dart';
//import 'package:e_wallet/BankInfoScreen/bloc/bank_info_events.dart';
//import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
//import 'package:e_wallet/MainScreen/main_screen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:http/http.dart' as http;
//
//class LoginPageBloc extends Bloc<LoginPageEvents, LoginPageStates> {
//  String accessToken;
//  final _auth = FirebaseAuth.instance;
//  bool showProgress = false;
//  String email, password, name, photoUrl;
//  var facebookLogin;
//  var profile;
//  var graphResponse;
//  FirebaseUser _user;
//  bool isSignInGoogle = false;
//  bool isSignInFacebook = false;
//  GoogleSignIn _googleSignIn = new GoogleSignIn(
//      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);
//
//  bool isSignIn;
//
//  @override
//  LoginPageStates get initialState => LoginPageInit();
//
//  getCredentials() async {
//    name = await CurrentUserSingleton().getUserName();
//    email = await CurrentUserSingleton().getEmail();
//    password = await CurrentUserSingleton().getPassword();
//    photoUrl = await CurrentUserSingleton().getPhotoUrl();
//  }
//
//  void _logInWithFacebook() async {
//    facebookLogin = new FacebookLogin();
//    var result = await facebookLogin.logIn(['email']);
//    FacebookAccessToken accessToken = result.accessToken;
//    AuthCredential credential =
//    FacebookAuthProvider.getCredential(accessToken: accessToken.token);
//
//    if (result.status == FacebookLoginStatus.loggedIn) {
//      try {
//        var facebookLoginResult = await facebookLogin.logIn(['email']);
//        var graphResponse = await http.get(
//            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(400)&access_token=${facebookLoginResult
//                .accessToken.token}');
//
//        var profile = json.decode(graphResponse.body);
//        isSignInFacebook = true;
//        isSignInGoogle = false;
//        accessToken =
//            CurrentUserSingleton().getAccessToken("testuser", "testuser");
//        CurrentUserSingleton().addJWT();
//        CurrentUserSingleton().addUserName(profile["name"]);
//        CurrentUserSingleton().addEmail(profile["email"]);
//        CurrentUserSingleton().addPhotoUrl(profile["picture"]["data"]["url"]);
//      }
//    } else if (result.status == FacebookLoginStatus.cancelledByUser) {
//      print("CancelledByUser");
//    } else if (result.status == FacebookLoginStatus.error) {
//      print("Error");
//    }
//  }
//
//  void _logoutFromFacebook() {
//    facebookLogin.logOut();
//      isSignInFacebook = false;
//    CurrentUserSingleton().removeJWT();
//    CurrentUserSingleton().removeCredentials();
//  }
//
//  void _logInWithGoogle() async {
//    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
//    GoogleSignInAuthentication googleSignInAuthentication =
//    await googleSignInAccount.authentication;
//
//    AuthCredential credential = GoogleAuthProvider.getCredential(
//        idToken: googleSignInAuthentication.idToken,
//        accessToken: googleSignInAuthentication.accessToken);
//
//    AuthResult result = (await _auth.signInWithCredential(credential));
//    _user = result.user;
//
//    accessToken = CurrentUserSingleton().getAccessToken("testuser", "testuser");
//    CurrentUserSingleton().addJWT();
//    CurrentUserSingleton().addUserName(_user.displayName);
//    CurrentUserSingleton().addEmail(_user.email);
//    CurrentUserSingleton().addPhotoUrl(_user.photoUrl);
//    print(accessToken);
//
//    setState(() {
//      isSignInGoogle = true;
//      isSignInFacebook = false;
//      print(_user.photoUrl);
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) =>
//                MainScreen(_user.displayName, _user.email, _user.photoUrl),
//          ));
//    });
//  }
//
//  Future<void> googleSignout() async {
//    await _auth.signOut().then((onValue) {
//      _googleSignIn.signOut();
//      setState(() {
//        isSignInGoogle = false;
//      });
//    });
//    CurrentUserSingleton().removeJWT();
//    CurrentUserSingleton().removeCredentials();
//    print(accessToken);
//  }
//
//  @override
//  Stream<LoginPageStates> mapEventToState(LoginPageEvents event) async* {
//    if (event is LoadLoginPage) {
//      accessToken =
//      await CurrentUserSingleton().getAccessToken("testuser", "testuser");
//      yield LoginPageLoaded();
//    }
//    if (event is ReloadLoginPage) {
//      yield LoginPageReloaded();
//    }
//  }
//
//  loadLoginPage() {
//    add(LoadLoginPage());
//  }
//}
