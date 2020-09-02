import 'package:dio/dio.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_state.dart';
import 'package:e_wallet/WalletsScreen/WalletCreate/bloc/wallet_create_events.dart';
import 'package:e_wallet/WalletsScreen/WalletCreate/bloc/wallet_create_states.dart';
import 'package:e_wallet/WalletsScreen/WalletCreate/wallet_create.dart';
import 'package:e_wallet/models/available_currency.dart';
import 'package:e_wallet/models/bank.dart';
import 'package:e_wallet/models/wallet.dart';
import 'package:e_wallet/rest/bank_repository.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalletCreateBloc extends Bloc<WalletCreateEvents, WalletCreateStates> {
  String currencyName;
  int currencyID;
  WalletCreateEvent _event;
  var response;
  Wallet wallet;
  List<Bank> banks = [];
  List<String> banksName = [];
  int bankID = 0;
  String bankName;
  List<AvailableCurrency> currencies = [];
  List<String> currenciesName = [];

  WalletCreateBloc(this._event) : super(WalletInit());

  @override
  Stream<WalletCreateStates> mapEventToState(WalletCreateEvents event) async* {
    if (event is LoadAvailableBanks) {
      banks = await BankRepository().getBanks(null);
      for (int i = 0; i < banks.length; i++) {
        banksName.add(banks[i].registered_name);
      }
      yield WalletCreated();
    }

    if (event is LoadAvailableCurrencies) {
      currencies =
          await WalletsRepository().getPossibleCurrencies(bankID, (error) {
        _event.onError(error);
      });

      for (int i = 0; i < currencies.length; i++) {
        if (!currenciesName.contains(currencies[i].abbr))
          currenciesName.add(currencies[i].abbr);
      }
      yield WalletCreated();
    }

    if (event is CreateWallet) {
      response = await WalletsRepository().createWallet(currencyID, (error) {
        _event.onError(error);
      });

      print("raspuns = " + response.toString());

      if (response != null) {
        print(response.data.toString());

        wallet = Wallet(
            response.data["id"],
            response.data["user"],
            response.data["currency"],
            response.data["balance"],
            response.data["value_buy"],
            response.data["value_sell"],
            response.data["profit"],
            currencyName);
        

        Fluttertoast.showToast(
            msg: "Wallet Created Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blueAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      yield WalletCreated();
    }

    if (event is RefreshWalletPage) {
      yield WalletCreated();
    }

    if (event is GetBankID) {
      bankID = await BankRepository().getBankID(bankName, (error) {
        print(error.toString());
        _event.onError(error);
      });
      loadAvailableCurrencies();
      yield WalletCreated();
    }

    if (event is GetCurrencyID) {
      currencyID = await BankRepository().getCurrencyID(currencyName, bankID, (error) {
        print(error.toString());
        _event.onError(error);
      });
      print("currencyID = " + currencyID.toString());
    }
  }

  createWallet() {
    add(CreateWallet());
  }

  loadAvailableBanks() {
    add(LoadAvailableBanks());
  }

  loadAvailableCurrencies() {
    add(LoadAvailableCurrencies());
  }

  getBankID() {
    add(GetBankID());
  }

  refreshWalletPage() {
    add(RefreshWalletPage());
  }

  getCurrencyID() {
    add(GetCurrencyID());
  }
}
