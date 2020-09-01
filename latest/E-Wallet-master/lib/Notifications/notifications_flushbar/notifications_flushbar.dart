import 'dart:async';

import 'package:e_wallet/Notifications/notifications_flushbar/bloc/notifications_bloc.dart';
import 'package:e_wallet/Notifications/notifications_flushbar/bloc/notifications_states.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../notifications_singleton.dart';

class NotificationsFlushbar extends StatefulWidget {
  @override
  NotificationsFlushbarState createState() => NotificationsFlushbarState();
}

class NotificationsFlushbarState extends State<NotificationsFlushbar>
    with NotificationFlushbarEvents {
  NotificationsBloc _notificationsBloc;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  OverlayEntry _overlayEntry;

  @override
  void initState() {
    _notificationsBloc = NotificationsBloc(this);
    _notificationsBloc.getNotification();

    super.initState();
  }

  OverlayEntry _createOverlayEntry(String title, String message) {
    _notificationsBloc.pushNotification();
    print("am intrat in functie");
    return OverlayEntry(
        builder: (context) =>
            BlocBuilder<NotificationsBloc, NotificationStates>(
              cubit: _notificationsBloc,
              builder: (context, state) {
                print("am intrat in functie");
                return Visibility(
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
                      backgroundGradient: LinearGradient(
                          colors: [Colors.blueGrey, Colors.black]),
                      isDismissible: true,
                      duration: Duration(seconds: 4),
                      icon: Icon(
                        Icons.event,
                        color: Colors.greenAccent,
                      ),
                      mainButton: FlatButton(
                        onPressed: () {
                          _notificationsBloc.hideNotification();
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
                  visible: _notificationsBloc.notification,
                );
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void onFCMTokenGot() {
    _notificationsBloc.sendFCMToken();
  }

  @override
  void onNotificationReceived() {
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {},
      onMessage: (Map<String, dynamic> message) async {
        final notification = message["notification"];
        this._overlayEntry = this
            ._createOverlayEntry(notification["title"], notification["body"]);
        Timer.run(() {
          Overlay.of(context).insert(this._overlayEntry);
        });
      },
      onResume: (Map<String, dynamic> message) async {},
    );
  }
}

abstract class NotificationFlushbarEvents {
  void onFCMTokenGot();

  void onNotificationReceived();
}
