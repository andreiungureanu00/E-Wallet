import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_state.dart';
import 'package:e_wallet/models/wallet.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';
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

  MainScreenBloc(this._event) : super(WalletsInit());

  @override
  Stream<MainScreenState> mapEventToState(MainScreenEvent event) async* {
    if (event is LoadWallets) {
      yield WalletsLoaded();
    }

    if (event is ReloadWallets) {
      yield WalletsLoaded();
    }

    if (event is LoadUser) {
      await CurrentUserSingleton().getCurrentUserAsync();
      yield WalletsLoaded();
    }
  }

  loadUser() {
    add(LoadUser());
  }

}
