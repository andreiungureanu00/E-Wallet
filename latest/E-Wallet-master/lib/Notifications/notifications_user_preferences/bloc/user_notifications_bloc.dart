import 'package:e_wallet/Notifications/notifications_list/notifications_list_page.dart';
import 'package:e_wallet/Notifications/notifications_user_preferences/bloc/user_notifications_events.dart';
import 'package:e_wallet/Notifications/notifications_user_preferences/bloc/user_notifications_states.dart';
import 'package:e_wallet/rest/notifications_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserNotificationsBloc
    extends Bloc<UserNotificationsEvents, UserNotificationsStates> {

  String defaultPercentage = "3";
  String defaultForecastPercentage = "3";
  List<String> percentsList = [];
  List<String> percentsForecastList = [];

  UserNotificationsBloc() : super(PageLoaded());

  @override
  Stream<UserNotificationsStates> mapEventToState(
      UserNotificationsEvents event) async* {
    if (event is InitPage) {
      yield PageLoaded();
    }

    if (event is ReloadPage) {
      yield PageLoaded();
    }

    if (event is SetPercentageDown) {
      await NotificationsRepository().setNotificationPercentageDown(int.parse(defaultPercentage));
      yield PercentageDownSet();
    }
    if (event is SetPercentageDownForecast) {
      await NotificationsRepository().setNotificationPercentageForecastDown(int.parse(defaultForecastPercentage));
      yield PercentageDownForecastSet();
    }
  }

  initList() {
    for (int i = 1; i <= 20; i++) {
      percentsList.add(i.toString());
      percentsForecastList.add(i.toString());
    }
  }

  initPage() {
    add(InitPage());
  }

  reloadPage() {
    add(ReloadPage());
  }

  setPercentageDown() {
    add(SetPercentageDown());
  }

  setPercentageForecastDown() {
    add(SetPercentageDownForecast());
  }
}
