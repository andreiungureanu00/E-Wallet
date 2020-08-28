import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_state.dart';
import 'package:e_wallet/Notifications/notifications_singleton.dart';
import 'package:e_wallet/models/wallet.dart';
import 'package:e_wallet/rest/notifications_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
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
//      await NotificationsSingleton().firebaseMessaging.deleteInstanceID();
      var token = await NotificationsSingleton().firebaseMessaging.getToken();

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
