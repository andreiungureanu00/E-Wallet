import 'package:dio/dio.dart';
import 'package:e_wallet/AuthScreen/LoginScreen/login_page_screen.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/Notifications/notifications_singleton.dart';
import 'package:e_wallet/models/bank.dart';
import 'package:e_wallet/models/user.dart';
import 'package:e_wallet/rest/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import 'login_page_events.dart';
import 'login_page_states.dart';

class LoginPageBloc extends Bloc<LoginPageEvents, LoginPageStates> {

  List<Bank> banks = [];
  String accessToken;
  var currentUser;
  final LocalAuthentication localAuth = LocalAuthentication();
  bool weCanCheckBiometrics;
  bool authenticated;
  String userEmail;
  LoginEvents _event;

  LoginPageBloc(this._event) : super(LoginPageInit());

  Future<String> loginWithCredentials(String username, String password) async {
    String accessToken;
    CurrentUser currentUser;

    try {
      accessToken = await AuthRepository().login(username, password, (error) {
        print(error.toString());
        _event.onError(error);
      });
    }
    catch(exception) {
      if (exception is DioError)
        print(exception.message);
    }

    await CurrentUserSingleton().setAccessTokenAsync(accessToken);
    currentUser = await AuthRepository().getUserFromServer(accessToken, (error) {
      print(error.toString());
      _event.onError(error);
    });

    var photoUrl =
        "https://scontent.fkiv4-1.fna.fbcdn.net/v/t1.30497-1/s480x480/84628273_176159830277856_972693363922829312_n.jpg?_nc_cat=1&_nc_sid=12b3be&_nc_ohc=EiCVFZsOtR0AX8bAVby&_nc_ht=scontent.fkiv4-1.fna&_nc_tp=7&oh=4ca52c73ce307020f39f4731f487731d&oe=5F3BA3AA";

    currentUser.photoUrl = photoUrl;
    currentUser.authCode = 3;

    CurrentUserSingleton().setCurrentUserAsync(currentUser);

    return accessToken;
  }

  @override
  Stream<LoginPageStates> mapEventToState(LoginPageEvents event) async* {
    if (event is LoadLoginPage) {
      yield LoginPageLoaded();
    }

    if (event is ReloadLoginPage) {
      yield LoginPageLoaded();
    }

    if (event is LoginWithFacebook) {
      currentUser =  await AuthRepository().logInWithFacebook((error) {
        print(error.toString());
        _event.onError(error);
      });
      await CurrentUserSingleton().setCurrentUserAsync(currentUser);
      accessToken = await AuthRepository().login("testuser", "testuser", (error) {
        print(error.toString());
        _event.onError(error);
      });
      await CurrentUserSingleton().setAccessTokenAsync(accessToken);
      _event.signInWithFacebook();
    }

    if (event is LogoutFromFacebook) {
      AuthRepository().logoutFromFacebook();
      await CurrentUserSingleton().setAccessTokenAsync(null);
      await CurrentUserSingleton().logout();
      NotificationsSingleton().setFCMToken(null);
    }

    if (event is LoginWithGoogle) {
      currentUser = await AuthRepository().logInWithGoogle((error) {
        print(error.toString());
        _event.onError(error);
      });
      accessToken = await AuthRepository().login("testuser", "testuser", (error) {
        print(error.toString());
        _event.onError(error);
      });
      await CurrentUserSingleton().setAccessTokenAsync(accessToken);
      await CurrentUserSingleton().setCurrentUserAsync(currentUser);
      _event.signInWithGoogle();
    }

    if (event is LogoutFromGoogle) {
      await AuthRepository().googleSignout();
      await CurrentUserSingleton().setAccessTokenAsync(null);
      await CurrentUserSingleton().logout();
      NotificationsSingleton().setFCMToken(null);
    }

  }

  loadLoginPage() {
    add(LoadLoginPage());
  }

  reloadLoginPage() {
    add(ReloadLoginPage());
  }

  loginWithFacebook() {
    add(LoginWithFacebook());
  }

  loginWithGoogle() {
    add(LoginWithGoogle());
  }

  logoutWithCredentials() {
    add(LogoutWithCredentials());
  }

  logoutFromFacebook() {
    add(LogoutFromFacebook());
  }

  logoutFromGoogle() {
    add(LogoutFromGoogle());
  }
}
