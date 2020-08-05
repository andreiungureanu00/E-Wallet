
import 'package:e_wallet/WalletsScreen/TransactionCreate/transaction_create.dart';
import 'package:e_wallet/WalletsScreen/WalletTransactions/bloc/wallet_transactions_events.dart';
import 'package:e_wallet/WalletsScreen/WalletTransactions/bloc/wallet_transactions_states.dart';
import 'package:e_wallet/WalletsScreen/WalletTransactions/wallet_transactions.dart';
import 'package:e_wallet/models/transaction.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletTransactionsBloc extends Bloc<WalletTransactionsEvents, WalletTransactionsStates> {

  int walletId;
  List<Transaction> transactions = [];
  WalletTransactionsEvent _event;

  WalletTransactionsBloc(this.walletId, this._event);

  @override
  WalletTransactionsStates get initialState => WalletTransactionsInit();

  @override
  Stream<WalletTransactionsStates> mapEventToState(WalletTransactionsEvents event) async* {
    if (event is LoadWalletTransactions) {
      transactions = await WalletsRepository().getTransactions(walletId, (error) {
        _event.onError(error);
      });
      yield WalletTransactionsLoaded();
    }
    if (event is ReloadWalletTransactions) {
      yield WalletTransactionsLoaded();
    }
  }

  loadWalletTransactions() {
    add(ReloadWalletTransactions());
    add(LoadWalletTransactions());
  }
}
