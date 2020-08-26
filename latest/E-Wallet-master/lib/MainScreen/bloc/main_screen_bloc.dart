import 'package:e_wallet/AuthScreen/LoginScreen/ChangePasswordScreen/bloc/change_password_events.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/CurrentUserSingleton/shared_preferences.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_state.dart';
import 'file:///D:/Android%20Projects/new_e_wallet/E-Wallet-master/latest/E-Wallet-master/lib/Notifications/notifications_list/notifications_list_page.dart';
import 'package:e_wallet/Notifications/notifications_singleton.dart';
import 'package:e_wallet/models/user.dart';
import 'package:e_wallet/models/wallet.dart';
import 'package:e_wallet/rest/notifications_repository.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main_screen.dart';
import 'main_screen_event.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenEvents _event;
  int walletID;
  final LocalAuthentication localAuth = LocalAuthentication();
  bool weCanCheckBiometrics;
  bool authenticated;
  Wallet updatedWallet;
  int counter = 0;
  List<Wallet> wallets;
  Wallet createdWallet;
  String fcmToken;
  bool notification;

  MainScreenBloc(this._event) : super(MainScreenInit());

  @override
  Stream<MainScreenState> mapEventToState(MainScreenEvent event) async* {
    if (event is LoadWallets) {
      yield MainScreenLoaded();
    }

    if (event is GetFCMToken) {
      await NotificationsSingleton().getFCMTokenAsync();
      fcmToken = NotificationsSingleton().getFCMToken();
      _event.onFCMTokenGot();
      yield MainScreenLoaded();
    }

    if (event is SendFCMToken) {
      var token = await NotificationsSingleton().firebaseMessaging.getToken();
//      if (token.compareTo(fcmToken) != 0)
      print("firebase token = $token");
        await NotificationsRepository().sendFCMToken(fcmToken);
    }

    if (event is LoadUser) {
      await CurrentUserSingleton().getCurrentUserAsync();
      yield MainScreenLoaded();
    }

    if (event is GetNotification) {
      await NotificationsSingleton().getNotifications();
      _event.onNotificationReceived();
    }

    if (event is ShowNotification) {
      notification = true;
      Future.delayed(Duration(seconds: 8)).then((value) {
        hideNotification();
        reloadPage();
      });
      yield HiddenNotification();
    }

    if (event is ReloadWallets) {
      yield MainScreenLoaded();
    }

    if (event is HideNotification) {
      notification = false;
      yield HiddenNotification();
    }

  }

  loadUser() {
    add(LoadUser());
  }

  getFCMToken() {
    add(GetFCMToken());
  }

  sendFCMToken() {
    add(SendFCMToken());
  }

  getNotification() {
    add(GetNotification());
  }

  reloadPage() {
    add(ReloadWallets());
  }

  pushNotification() {
    add(ShowNotification());
  }

  hideNotification() {
    add(HideNotification());
  }
}
