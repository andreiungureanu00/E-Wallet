import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:e_wallet/BankInfoScreen/bloc/bank_info_events.dart';
import 'package:e_wallet/BankInfoScreen/bloc/bank_info_states.dart';
import 'package:e_wallet/models/bank.dart';
import 'package:e_wallet/models/coin.dart';
import 'package:e_wallet/models/rate.dart';
import 'package:e_wallet/rest/bank_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BankInfoBloc extends Bloc<BankInfoEvents, BankInfoStates> {
  @override
  BankInfoStates get initialState => BankInfoInit();

  Dio dio;
  Rate rate;
  List<Coin> coins;
  List<Rate> rates;
  int bankId;
  Bank bank;
  String url = "https://live.curs-valutar.xyz";

  // ignore: non_constant_identifier_names
  int nr_elements;
  int coinId;

  // ignore: non_constant_identifier_names
  int page_size = 20;

  BankInfoBloc(this.bank);


  @override
  Stream<BankInfoStates> mapEventToState(BankInfoEvents event) async* {
    if (event is LoadBankInfo) {
      print("Banca " + bank.id.toString());
      coins = await BankRepository().getAvailableCoins(bank.id);
      yield BankInfoLoaded();
    }
    if (event is ReloadBankInfo) {
      yield BankInfoLoaded();
    }
  }

  loadBankInfo() {
    add(LoadBankInfo());
  }
}
