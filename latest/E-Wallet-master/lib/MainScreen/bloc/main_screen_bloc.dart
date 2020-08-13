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
      wallets = await WalletsRepository().getWallets((error) {
        print(error.toString());
        _event.onError(error);
      });
      _event.loadWallets();

      if (createdWallet != null) {
        wallets.add(createdWallet);
        reloadWallets();
      }

      yield WalletsLoaded();
    }

    if (event is ReloadWallets) {
      yield WalletsLoaded();
    }

    if (event is LoadUser) {
      await CurrentUserSingleton().getCurrentUserAsync();
      yield WalletsLoaded();
    }

    if (event is DeleteWallet) {
      await WalletsRepository().deleteWallet(walletID, onError);
      for (var element in wallets) {
        if (element.id == walletID) {
          wallets.remove(element);
          break;
        }
      }
      reloadWallets();
    }

    if (event is AddNewWallet) {
      if (createdWallet != null) {
        wallets.add(createdWallet);
        reloadWallets();
      }
    }

    if (event is UpdateWalletBalance) {
      if (updatedWallet != null) {
        for (int i = 0; i < wallets.length; i++) {
          if (wallets[i].id == updatedWallet.id) {
            print("inainte balance = " + wallets[i].balance);
            wallets[i].balance = updatedWallet.balance;
          }
          print("apoi balance = " + wallets[i].balance);
        }
        reloadWallets();
      }
      reloadWallets();
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

  loadUser() {
    add(LoadUser());
  }

  addNewWallet() {
    add(AddNewWallet());
  }

  updateWalletBalance() {
    add(UpdateWalletBalance());
  }
}
