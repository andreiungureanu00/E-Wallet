import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/models/NotificationMessage.dart';
import 'package:e_wallet/rest/StringConfigs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsSingleton {
  static final NotificationsSingleton _singleton =
      new NotificationsSingleton._internal();

  factory NotificationsSingleton() {
    return _singleton;
  }

  NotificationsSingleton._internal();

  // ignore: non_constant_identifier_names
  var fcm_token;
  bool tokenSent = false;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  List<NotificationMessage> messages = [];
  var notification;

  getFCMTokenAsync() async {
    fcm_token = await firebaseMessaging.getToken();
    setFCMToken(fcm_token);
  }

  String getFCMToken() {
    return fcm_token;
  }

  setFCMToken(String fcmToken) {
    this.fcm_token = fcmToken;
  }

  getNotifications() async {
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print("am primit mesaj in launch");
      },
      onMessage: (Map<String, dynamic> message) async {
        notification = message["notification"];
        print(notification["body"]);
      },
      onResume: (Map<String, dynamic> message) async {},
    );
  }


}
