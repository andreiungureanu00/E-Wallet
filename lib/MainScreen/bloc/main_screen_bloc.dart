import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_state.dart';
import 'package:e_wallet/models/coin.dart';
import 'package:e_wallet/models/user.dart';
import 'package:e_wallet/models/wallet.dart';
import 'package:e_wallet/rest/auth_repository.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main_screen.dart';
import 'main_screen_event.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {

   User currentUser;
   MainScreenEvents _event;

   MainScreenBloc(this._event);

  @override
  MainScreenState get initialState => WalletsInit();

  List<Wallet> wallets;
  String accessToken;
  int errorCode;

  @override
  Stream<MainScreenState> mapEventToState(MainScreenEvent event) async* {
    if (event is LoadWallets) {
      await CurrentUserSingleton().getCurrentUserAsync();
      currentUser = CurrentUserSingleton().getCurrentUser();
      print("in bloc : " + currentUser.username);
      wallets = await WalletsRepository().getWallets((error){
        print(error.toString());
        _event.onError(error);
      });
      yield WalletsLoaded();
    }
//    if (event is DeleteWallet) {
//      await WalletsRepository().deleteWallet(walletId, onError)
//      yield WalletsLoaded();
//    }
    if (event is ReloadWallets) {
      yield WalletsLoaded();
    }
  }

  loadWallets() {
    add(LoadWallets());
  }

  reloadWallets() {
    add(ReloadWallets());
  }

  deleteWallet() {
    add(DeleteWallet());
  }
}
