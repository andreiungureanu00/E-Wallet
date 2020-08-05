

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
  String accessToken;
  User currentUser;

  @override
  Stream<LoginPageStates> mapEventToState(LoginPageEvents event) async* {
    if (event is LoadLoginPage) {
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
