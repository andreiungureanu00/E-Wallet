import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_state.dart';
import 'package:e_wallet/WalletsScreen/TransactionCreate/bloc/transaction_create_events.dart';
import 'package:e_wallet/WalletsScreen/TransactionCreate/bloc/transaction_create_states.dart';
import 'package:e_wallet/WalletsScreen/TransactionCreate/transaction_create.dart';
import 'package:e_wallet/models/coin.dart';
import 'package:e_wallet/models/wallet.dart';
import 'package:e_wallet/rest/auth_repository.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCreateBloc
    extends Bloc<TransactionCreateEvents, TransactionCreateStates> {
  int walletID;
  int currency;
  String currencyName;
  int currencyID;
  double amount;
  OnError _event;

  TransactionCreateBloc(this.walletID, this.currency, this._event);

  @override
  TransactionCreateStates get initialState => TransactionInit();

  @override
  Stream<TransactionCreateStates> mapEventToState(
      TransactionCreateEvents event) async* {
    if (event is CreateTransaction) {
      print(walletID.toString() +
          " " +
          amount.toString() +
          " " +
          currency.toString());
      var response = await WalletsRepository()
          .newTransaction(walletID, amount, currency, (error) {
        _event.onError(error);
      });

      yield TransactionCreated();
    }
    if (event is ReloadTransaction) {
      yield TransactionReloaded();
    }
  }

  createTransaction() {
    add(CreateTransaction());
  }
}
