

import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/MainScreen/main_screen.dart';
import 'package:e_wallet/models/bank.dart';
import 'package:e_wallet/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_page_events.dart';
import 'login_page_states.dart';

class LoginPageBloc extends Bloc<LoginPageEvents, LoginPageStates> {

  @override
  LoginPageStates get initialState => LoginPageInit();
  List<Bank> banks = [];
  int authCode;
  String accessToken;
  User currentUser;
  bool isSignInFacebook = false;
  bool isSignInGoogle = false;
  bool isSignIn = false;

  Future<void> getData() async {
    await CurrentUserSingleton().getAccessTokenAsync();
    accessToken = CurrentUserSingleton().getAccessToken();
    await CurrentUserSingleton().getCurrentUserAsync();
    currentUser = CurrentUserSingleton().getCurrentUser();

    if (currentUser != null) {
      authCode = currentUser.authCode;

      if (authCode == 1) {
        isSignInFacebook = true;
        isSignInGoogle = false;
        isSignIn = false;
      } else if (authCode == 2) {
        isSignInGoogle = true;
        isSignInFacebook = false;
        isSignIn = false;
      } else if (authCode == 3) {
        isSignIn = true;
        isSignInFacebook = false;
        isSignInGoogle = false;
      }
    } else {
      print("nu sunt logat");
    }
  }

  void setFlags(bool facebookValue, bool googleValue, bool loginValue) {
    isSignInFacebook = facebookValue;
    isSignInGoogle = googleValue;
    isSignIn = loginValue;
  }

  @override
  Stream<LoginPageStates> mapEventToState(LoginPageEvents event) async* {
    if (event is LoadLoginPage) {
      await getData();
      yield LoginPageLoaded();
    }

    if (event is SetFlags) {
      yield LoginPageLoaded();
    }

    if (event is ReloadLoginPage) {
      yield LoginPageLoaded();
    }
  }

  loadLoginPage() {
    add(LoadLoginPage());
  }

  reloadLoginPage() {
    add(ReloadLoginPage());
  }

}
