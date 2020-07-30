
import 'package:e_wallet/AuthScreen/login_page_screen.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/MainScreen/main_screen.dart';
import 'package:e_wallet/ReportsScreen/reports_screen.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';


void main() async {
  String accessToken;
  User currentUser;

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());

}

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyLoginPage(),
    );
  }
}

