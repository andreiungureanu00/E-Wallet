import 'package:e_wallet/MainScreen/main_screen.dart';

import 'AuthScreen/LoginScreen/login_page_screen.dart';
import 'package:flutter/material.dart';

import 'CurrentUserSingleton/current_user_singleton.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String accessToken;
  User currentUser;
  bool isSignInFacebook;
  bool isSignInGoogle;
  bool isSignIn;
  var authCode;

  Future<void> getData() async {
    await CurrentUserSingleton().getAccessTokenAsync();
    accessToken = CurrentUserSingleton().getAccessToken();
    await CurrentUserSingleton().getCurrentUserAsync();
    currentUser = CurrentUserSingleton().getCurrentUser();

    if (currentUser != null) {
      authCode = currentUser.authCode;

      if (authCode == 1) {
        isSignInFacebook = true;
        isSignInGoogle = false;
        isSignIn = false;
      } else if (authCode == 2) {
        isSignInGoogle = true;
        isSignInFacebook = false;
        isSignIn = false;
      } else if (authCode == 3) {
        isSignIn = true;
        isSignInFacebook = false;
        isSignInGoogle = false;
      }
    } else {
      print("nu sunt logat");
    }
  }

  await getData();

  runApp(MyApp(currentUser));
}

class MyApp extends StatelessWidget {
  final currentUser;

  MyApp(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: currentUser == null ? MyLoginPage(0) : MainScreen(currentUser),
    );
  }
}
