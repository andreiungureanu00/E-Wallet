
import 'package:e_wallet/Notifications/notifications_list/bloc/notifications_list_events.dart';
import 'package:e_wallet/Notifications/notifications_list/notifications_list_page.dart';
import 'package:e_wallet/models/NotificationMessage.dart';
import 'package:e_wallet/rest/notifications_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifications_list_states.dart';

class NotificationsListBloc extends Bloc<NotificationsListEvents, NotificationsListStates> {

  List<NotificationMessage> notificationsList = [];
  NotificationsEvents _event;

  NotificationsListBloc(_event) : super(NotificationsScreenInit());

  @override
  Stream<NotificationsListStates> mapEventToState(NotificationsListEvents event) async*{
    if (event is LoadNotifications) {
      notificationsList = await NotificationsRepository().getNotifications((error) {
        print(error.toString());
      });
      refreshNotifications();
      yield NotificationsScreenLoaded();
    }

    if (event is ReloadNotifications) {
      yield NotificationsScreenLoaded();
    }

    if (event is ClearNotificationsList) {
      notificationsList.removeRange(0, notificationsList.length);
      yield NotificationsScreenLoaded();
    }
  }

  loadNotifications() {
    add(LoadNotifications());
  }

  refreshNotifications() {
    add(ReloadNotifications());
  }

  clearNotificationsList() {
    add(ClearNotificationsList());
  }
}