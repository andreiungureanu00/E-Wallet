
import 'dart:async';

import 'package:e_wallet/MainScreen/main_screen.dart';
import 'package:e_wallet/Notifications/NotificationFlushBar/bloc/notification_flushbar_bloc.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationFlusbar extends StatefulWidget {
  @override
  NotificationFlusbarState createState() => NotificationFlusbarState();
}

class NotificationFlusbarState extends State<NotificationFlusbar> with MainScreenEvents{

  NotificationFlushbarBloc _flushbarBloc;
  OverlayEntry _overlayEntry;

  @override
  void initState() {
    _flushbarBloc = NotificationFlushbarBloc();
    super.initState();
  }

  OverlayEntry _createOverlayEntry(String title, String message) {
    var visibility = true;
    Future.delayed(Duration(seconds: 4)).then((value) {
      setState(() {
        visibility = false;
      });
    });
    return OverlayEntry(
        builder: (context) => Visibility(
          child: AnimatedContainer(
            height: 40,
            duration: Duration(seconds: 5),
            alignment: Alignment.topCenter,
            child: Flushbar(
              title: title,
              message: message,
              flushbarPosition: FlushbarPosition.TOP,
              flushbarStyle: FlushbarStyle.FLOATING,
              reverseAnimationCurve: Curves.decelerate,
              forwardAnimationCurve: Curves.elasticOut,
              backgroundColor: Colors.red,
              boxShadows: [
                BoxShadow(
                    color: Colors.blue[800],
                    offset: Offset(0.0, 2.0),
                    blurRadius: 3.0)
              ],
              backgroundGradient:
              LinearGradient(colors: [Colors.blueGrey, Colors.black]),
              isDismissible: false,
              duration: Duration(seconds: 4),
              icon: Icon(
                Icons.check,
                color: Colors.greenAccent,
              ),
              mainButton: FlatButton(
                onPressed: () {
                  setState(() {
                    visibility = false;
                  });
                },
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              showProgressIndicator: true,
              progressIndicatorBackgroundColor: Colors.blueGrey,
              titleText: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.yellow[600],
                    fontFamily: "ShadowsIntoLightTwo"),
              ),
              messageText: Text(
                message,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.green,
                    fontFamily: "ShadowsIntoLightTwo"),
              ),
            ),
          ),
          visible: visibility,
        ));
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
  }

  @override
  void loadWallets() {
  }

  @override
  void onError(errorText) {
  }

  @override
  void onFCMTokenGot() {
  }

  @override
  void onNotificationReceived() {
    _flushbarBloc.firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {},
      onMessage: (Map<String, dynamic> message) async {
        final notification = message["notification"];
        this._overlayEntry = this._createOverlayEntry(notification["title"], notification["body"]);
        Timer.run(() {
          Overlay.of(context).insert(this._overlayEntry);
        });
        _flushbarBloc.pushNotification();
      },
      onResume: (Map<String, dynamic> message) async {},
    );
  }

  @override
  void loadNotifications() {
    // TODO: implement loadNotifications
  }

}