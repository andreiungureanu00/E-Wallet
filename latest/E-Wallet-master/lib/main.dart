
import 'AuthScreen/FingerPrintScreen/finger_print_screen.dart';
import 'AuthScreen/LoginScreen/login_page_screen.dart';
import 'package:flutter/material.dart';

import 'CurrentUserSingleton/current_user_singleton.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String accessToken;
  await CurrentUserSingleton().getAccessTokenAsync();
  accessToken = CurrentUserSingleton().getAccessToken();
  print(accessToken);

  runApp(MyApp(accessToken));
}

class MyApp extends StatelessWidget {
  final accessToken;

  MyApp(this.accessToken);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: accessToken == null ? MyLoginPage() : FingerPrintScreen(),
    );
  }
}
