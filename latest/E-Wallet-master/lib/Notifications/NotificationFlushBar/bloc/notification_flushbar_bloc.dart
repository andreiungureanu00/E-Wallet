import 'package:e_wallet/Notifications/NotificationFlushBar/bloc/notification_flushbar_events.dart';
import 'package:e_wallet/Notifications/NotificationFlushBar/bloc/notification_flushbar_states.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../notifications_singleton.dart';

class NotificationFlushbarBloc
    extends Bloc<NotificationFlushbarEvents, NotificationFlushbarStates> {
  bool visibility = false;
  OverlayEntry _overlayEntry;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  NotificationFlushbarBloc() : super(HiddenFlushbar());

  pushNotification() {
    showNotification();
    Future.delayed(const Duration(seconds: 6)).then((value) {
      hideNotification();
      reloadNotification();
    });
  }


  @override
  Stream<NotificationFlushbarStates> mapEventToState(
      NotificationFlushbarEvents event) async* {
    if (event is ShowNotificationFlushbar) {
      visibility = true;
      yield ShownFlushbar();
    }

    if (event is HideNotificationFlushbar) {
      visibility = false;
      yield HiddenFlushbar();
    }

//    if (event is ReloadNotificationFlushbar) {
//      yield ShownFlushbar();
//    }
  }

  showNotification() {
    add(ShowNotificationFlushbar());
  }

  hideNotification() {
    add(HideNotificationFlushbar());
  }

  reloadNotification() {
    add(ReloadNotificationFlushbar());
  }

}
