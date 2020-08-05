import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:e_wallet/models/bank.dart';
import 'package:e_wallet/models/coin.dart';
import 'package:e_wallet/models/rate.dart';
import 'package:e_wallet/rest/StringConfigs.dart';
import 'file:///D:/Android%20Projects/new_e_wallet/E-Wallet-master/lib/Exceptions/api_handler.dart';
import 'file:///D:/Android%20Projects/new_e_wallet/E-Wallet-master/lib/Exceptions/app_exceptions.dart';

class BankRepository {
  static final BankRepository _singleton = new BankRepository._internal();

  factory BankRepository() {
    return _singleton;
  }

  BankRepository._internal();

  Future<dynamic> getBanks(Function onError) async {
    Response response;
    Dio dio = new Dio();
    List<Bank> banks = [];
    var responseJson;

    dio.interceptors.add(DioCacheManager(CacheConfig(
            baseUrl: "${StringConfigs.baseApiUrl}/banks/bank/?format=json"))
        .interceptor);

    try {
      response =
          await dio.get("${StringConfigs.baseApiUrl}/banks/bank/?format=json",
              options: buildCacheOptions(
                Duration(days: 7),
                maxStale: Duration(days: 10),
                forceRefresh: true,
              ));

      for (var i in response.data["results"]) {
        Bank bank = Bank.fromJson(i);
        banks.add(bank);
      }
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }
    return banks;
  }

  Future<List<Coin>> getAvailableCoins(int bankID, Function onError) async {
    Response response;
    Dio dio = new Dio();
    Rate rate;
    List<Coin> coins = List();

//    dio.interceptors.add(DioCacheManager(CacheConfig(
//            baseUrl:
//                "${StringConfigs.baseApiUrl}/banks/coin/$bankID/?format=json"))
//        .interceptor);

    try {
      response = await dio.get(
          "${StringConfigs.baseApiUrl}/banks/coin/$bankID/?format=json",
          options: buildCacheOptions(
            Duration(days: 7),
          ));

      for (var i in response.data["results"]) {
        Coin coin = Coin.fromJson(i);

        dio.interceptors.add(DioCacheManager(CacheConfig(
                baseUrl:
                    "${StringConfigs.baseApiUrl}/statistics/live/${coin.id}/?format=json"))
            .interceptor);

        response = await dio.get(
            "${StringConfigs.baseApiUrl}/statistics/live/${coin.id}/?format=json",
            options: buildCacheOptions(
              Duration(days: 7),
              maxStale: Duration(days: 10),
              forceRefresh: true,
            ));

        if (response.statusCode == 200) {
          rate = Rate.fromJson(response.data);
          coin.rate_sell = rate.rate_sell;
          coin.rate_buy = rate.rate_buy;

          coins.add(coin);
        }
      }
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }

    return coins;
  }
}
