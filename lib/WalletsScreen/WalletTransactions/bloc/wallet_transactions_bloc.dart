import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_state.dart';
import 'package:e_wallet/WalletsScreen/TransactionCreate/bloc/transaction_create_events.dart';
import 'package:e_wallet/WalletsScreen/TransactionCreate/bloc/transaction_create_states.dart';
import 'package:e_wallet/WalletsScreen/TransactionCreate/transaction_create.dart';
import 'package:e_wallet/WalletsScreen/WalletCreate/bloc/wallet_create_events.dart';
import 'package:e_wallet/WalletsScreen/WalletCreate/bloc/wallet_create_states.dart';
import 'package:e_wallet/WalletsScreen/WalletTransactions/bloc/wallet_transactions_events.dart';
import 'package:e_wallet/WalletsScreen/WalletTransactions/bloc/wallet_transactions_states.dart';
import 'package:e_wallet/models/coin.dart';
import 'package:e_wallet/models/transaction.dart';
import 'package:e_wallet/models/wallet.dart';
import 'package:e_wallet/rest/auth_repository.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletTransactionsBloc extends Bloc<WalletTransactionsEvents, WalletTransactionsStates> {

  int walletId;
  List<Transaction> transactions = [];

  WalletTransactionsBloc(this.walletId);

  @override
  WalletTransactionsStates get initialState => WalletTransactionsInit();

  @override
  Stream<WalletTransactionsStates> mapEventToState(WalletTransactionsEvents event) async* {
    if (event is LoadWalletTransactions) {
      transactions = await WalletsRepository().getTransactions(walletId);
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
