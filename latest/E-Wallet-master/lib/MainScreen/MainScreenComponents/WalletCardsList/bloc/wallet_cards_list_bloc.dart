import 'package:e_wallet/MainScreen/MainScreenComponents/WalletCardsList/bloc/wallet_cards_list_events.dart';
import 'package:e_wallet/MainScreen/MainScreenComponents/WalletCardsList/bloc/wallet_cards_list_states.dart';
import 'package:e_wallet/MainScreen/MainScreenComponents/WalletCardsList/wallet_cards_list.dart';
import 'package:e_wallet/models/wallet.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../main_screen.dart';

class WalletCardsListBloc extends Bloc<WalletCardsListEvents, WalletCardsListStates> {
  MainScreenEvents _event;

  int walletID;
  Wallet updatedWallet;
  int counter = 0;
  List<Wallet> wallets;
  Wallet createdWallet;

  WalletCardsListBloc(this._event) : super(WalletsInit());

  @override
  Stream<WalletCardsListStates> mapEventToState(WalletCardsListEvents event) async*{
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
            wallets[i].balance = updatedWallet.balance;
          }
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

  addNewWallet() {
    add(AddNewWallet());
  }

  updateWalletBalance() {
    add(UpdateWalletBalance());
  }
}
