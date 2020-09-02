import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/models/NotificationMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'StringConfigs.dart';

class NotificationsRepository {
  final _auth = FirebaseAuth.instance;

  static final NotificationsRepository _singleton =
      new NotificationsRepository._internal();

  factory NotificationsRepository() {
    return _singleton;
  }

  NotificationsRepository._internal();

  bool tokenSent;

  Future<void> sendFCMToken(String fcmToken) async {
    Dio dio = new Dio();
    String accessToken;

    await CurrentUserSingleton().getAccessTokenAsync();
    accessToken = CurrentUserSingleton().getAccessToken();

    Map<String, dynamic> body = {
      "registration_id": fcmToken,
      "type": "android"
    };

    String urlToken = "${StringConfigs.baseApiUrl}/devices/";

    try {
      if (tokenSent == false) {
        var response = await dio.post(urlToken,
            data: body,
            options: Options(headers: {
              HttpHeaders.authorizationHeader: "Bearer $accessToken"
            }));
        if (response != null) {
          tokenSent = true;
          print(response.toString());
        }
      }
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
    }
  }

  Future<List<NotificationMessage>> getNotifications(Function onError) async {
    Response response;
    List<NotificationMessage> notifications = List();
    Dio dio = new Dio();
    String accessToken;

    accessToken = CurrentUserSingleton().getAccessToken();

    dio.interceptors.add(DioCacheManager(CacheConfig(
            baseUrl: "${StringConfigs.baseApiUrl}/notifications/all/"))
        .interceptor);

    try {
      response = await dio.get(
          "${StringConfigs.baseApiUrl}/notification/notifications/all/",
          options: buildCacheOptions(Duration(days: 7),
              maxStale: Duration(days: 10),
              forceRefresh: true,
              options: Options(headers: {
                HttpHeaders.authorizationHeader: "Bearer $accessToken"
              })));

      print(response.data.toString());

      for (var element in response.data) {
        NotificationMessage notificationMessage = NotificationMessage(
            element["id"],
            element["verb"],
            element["target_object_id"],
            element["unread"]);
        if (!notifications.contains(notificationMessage))
          notifications.add(notificationMessage);
      }
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }

    return notifications;
  }

  setNotificationPercentageDown(int percentageDown, Function onError) async {
    Dio dio = new Dio();
    var response;
    var accessToken;

    accessToken = CurrentUserSingleton().getAccessToken();

    Map<String, dynamic> body = {"percentage_down": percentageDown};

    try {
      response = await dio.put("${StringConfigs.baseApiUrl}/users/preferences/",
          data: body,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $accessToken"
          }));
      print(response.toString());
    } catch (exception) {
      if (exception is DioError) onError(exception.error);
    }
  }

  setNotificationPercentageForecastDown(
      int percentageForecastDown, Function onError) async {
    Dio dio = new Dio();
    var response;
    var accessToken;

    accessToken = CurrentUserSingleton().getAccessToken();

    Map<String, dynamic> body = {
      "percentage_down_forecast": percentageForecastDown
    };

    try {
      response = await dio.put("${StringConfigs.baseApiUrl}/users/preferences/",
          data: body,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $accessToken"
          }));
      print(response.toString());
    } catch (exception) {
      if (exception is DioError) onError(exception.error);
    }
  }
}
