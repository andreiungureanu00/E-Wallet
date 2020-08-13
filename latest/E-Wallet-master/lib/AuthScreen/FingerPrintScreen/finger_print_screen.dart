
import 'package:e_wallet/AuthScreen/FingerPrintScreen/bloc/fingerprint_screen_bloc.dart';
import 'package:e_wallet/MainScreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FingerPrintScreen extends StatefulWidget {
  @override
  FingerPrintScreenState createState() => FingerPrintScreenState();
}

class FingerPrintScreenState extends State<FingerPrintScreen> with FingerPrintEvent{
  final LocalAuthentication localAuth = LocalAuthentication();
  // ignore: close_sinks
  FingerPrintScreenBloc _fingerPrintScreenBloc;

  @override
  void initState() {
    _fingerPrintScreenBloc = FingerPrintScreenBloc(this);
    _fingerPrintScreenBloc.takeFingerPrint();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.dark,
          textTheme: TextTheme(
            headline5: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
    );
  }

  @override
  void onFingerPrintTaken() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainScreen()));
  }
}

abstract class FingerPrintEvent {
  void onFingerPrintTaken();
}
