
import 'package:e_wallet/WalletsScreen/TransactionCreate/bloc/transaction_create_events.dart';
import 'package:e_wallet/WalletsScreen/TransactionCreate/bloc/transaction_create_states.dart';
import 'package:e_wallet/WalletsScreen/TransactionCreate/transaction_create.dart';
import 'package:e_wallet/models/transaction.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TransactionCreateBloc
    extends Bloc<TransactionCreateEvents, TransactionCreateStates> {
  int walletID;
  int currency;
  String currencyName;
  int currencyID;
  double amount;
  OnError _event;
  Transaction transaction;

  TransactionCreateBloc(this.walletID, this.currency, this._event) : super(TransactionInit());

  @override
  Stream<TransactionCreateStates> mapEventToState(
      TransactionCreateEvents event) async* {
    if (event is CreateTransaction) {
      var response = await WalletsRepository()
          .newTransaction(walletID, amount, currency, (error) {
        _event.onError(error);
      });

      print("transaction in bloc " + response.toString());

      currencyName = await WalletsRepository().getCurrencyById(response["currency"], onError);
      transaction = Transaction(response["id"], response["amount"], response["wallet"]["id"], response["wallet"]["currency"]["id"], response["rate"], response["wallet"]["currency"]["abbr"]);

      if (response != null) {
        Fluttertoast.showToast(
            msg: "Transaction Done Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blueAccent,
            textColor: Colors.white,
            fontSize: 16.0);

      }

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
