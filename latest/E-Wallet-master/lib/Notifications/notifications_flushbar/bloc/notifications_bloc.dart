import 'package:e_wallet/Notifications/notifications_flushbar/bloc/notifications_events.dart';
import 'package:e_wallet/Notifications/notifications_flushbar/notifications_flushbar.dart';
import 'package:e_wallet/rest/notifications_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../notifications_singleton.dart';
import 'notifications_states.dart';

class NotificationsBloc extends Bloc<NotificationEvents, NotificationStates> {
  String fcmToken;
  bool notification = true;
  NotificationFlushbarEvents _event;

  NotificationsBloc(this._event) : super(HiddenNotification());

  @override
  Stream<NotificationStates> mapEventToState(NotificationEvents event) async* {
    if (event is SendFCMToken) {
      var token = await NotificationsSingleton().firebaseMessaging.getToken();

      print("firebase token = $token");
      await NotificationsRepository().sendFCMToken(fcmToken);
    }
    if (event is GetNotification) {
      await NotificationsSingleton().getNotifications();
      _event.onNotificationReceived();
    }

    if (event is ShowNotification) {
      notification = true;
      Future.delayed(Duration(seconds: 8)).then((value) {
        hideNotification();
      });
      yield HiddenNotification();
    }

    if (event is HideNotification) {
      notification = false;
      yield HiddenNotification();
    }
  }

  sendFCMToken() {
    add(SendFCMToken());
  }

  getNotification() {
    add(GetNotification());
  }

  pushNotification() {
    add(ShowNotification());
  }

  hideNotification() {
    add(HideNotification());
  }

}
