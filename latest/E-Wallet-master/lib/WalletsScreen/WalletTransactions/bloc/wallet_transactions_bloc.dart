import 'package:e_wallet/WalletsScreen/WalletTransactions/bloc/wallet_transactions_events.dart';
import 'package:e_wallet/WalletsScreen/WalletTransactions/bloc/wallet_transactions_states.dart';
import 'package:e_wallet/WalletsScreen/WalletTransactions/wallet_transactions.dart';
import 'package:e_wallet/models/transaction.dart';
import 'package:e_wallet/models/wallet.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletTransactionsBloc
    extends Bloc<WalletTransactionsEvents, WalletTransactionsStates> {
  int walletId;
  List<Transaction> transactions = [];
  WalletTransactionsEvent _event;
  String currencyName;
  Transaction createdTransaction;
  Wallet updatedWallet;

  WalletTransactionsBloc(this.walletId, this._event) : super(WalletTransactionsInit());

  @override
  Stream<WalletTransactionsStates> mapEventToState(
      WalletTransactionsEvents event) async* {
    if (event is LoadWalletTransactions) {
      transactions =
          await WalletsRepository().getTransactions(walletId, (error) {
        _event.onError(error);
      });

      print("am scos tranzactiile");

      yield WalletTransactionsLoaded();
    }

    if (event is ReloadWalletTransactions) {
      yield WalletTransactionsLoaded();
    }

    if (event is AddTransaction) {
      if (createdTransaction != null) {
        transactions.add(createdTransaction);
      }
      yield WalletTransactionsLoaded();
    }

    if (event is UpdateWallet) {
      updatedWallet = await WalletsRepository().getUpdatedWallet(walletId, (error) {
        _event.onError(error);
      });
      _event.walletUpdated();
      yield WalletTransactionsLoaded();
    }

    if (event is ClearHistory) {
      transactions.removeRange(0, transactions.length);
      reloadTransactions();
    }
  }

  loadWalletTransactions() {
    add(ReloadWalletTransactions());
    add(LoadWalletTransactions());
  }

  reloadTransactions() {
    add(ReloadWalletTransactions());
  }

  addTransaction() {
    add(AddTransaction());
  }

  updateWallet() {
    add(UpdateWallet());
  }

  clearHistory() {
    add(ClearHistory());
  }
}
