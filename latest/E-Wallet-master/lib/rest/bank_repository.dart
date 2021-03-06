import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:e_wallet/models/available_currency.dart';
import 'package:e_wallet/models/bank.dart';
import 'package:e_wallet/models/coin.dart';
import 'package:e_wallet/models/rate.dart';
import 'package:e_wallet/rest/StringConfigs.dart';
import 'package:flutter/cupertino.dart';

class BankRepository {
  static final BankRepository _singleton = new BankRepository._internal();

  factory BankRepository() {
    return _singleton;
  }

  BankRepository._internal();

  Future<List<Bank>> getBanks(Function onError) async {
    Response response;
    Dio dio = new Dio();
    List<Bank> banks = [];

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
        banks.insert(0, bank);
      }

      return banks;
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }

    return null;
  }

  Future<String> getRatePrediction(
      int coinID, String date, Function onError) async {
    var response;
    Dio dio = new Dio();
    var value_sell;

    try {
      response = await dio.get(
          "${StringConfigs.baseApiUrl}/exchange/prediction/?date=$date&currency=$coinID");

      print(response.toString());

      for (var element in response.data) {
        value_sell = element["rate_sell"];
      }
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }

    return value_sell.toString();
  }

  Future<List<Rate>> getAvailableRates(int bankID, Function onError) async {
    Response response;
    Dio dio = new Dio();
    List<Rate> rates = List();

    dio.interceptors.add(DioCacheManager(CacheConfig(
            baseUrl:
                "/exchange/prediction/?date=2020-09-04&currency=378/statistics/live/bank/$bankID/?format=json"))
        .interceptor);

    try {
      response = await dio.get(
          "${StringConfigs.baseApiUrl}/statistics/live/bank/$bankID/?format=json",
          options: buildCacheOptions(
            Duration(days: 7),
          ));

      for (var element in response.data) {
        Rate rate = Rate(
            element["id"],
            element["rate_sell"],
            element["rate_buy"],
            element["date"],
            element["currency"]["id"],
            element["currency"]["abbr"]);
        rates.insert(0, rate);
      }
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }

    return rates;
  }

  Future<int> getBankID(String name, Function onError) async {
    Response response;
    Dio dio = new Dio();
    int bankID;

    try {
      response = await dio.get(
          "${StringConfigs.baseApiUrl}/exchange/banks/?format=json&registered_name=$name");

      for (var element in response.data) {
        bankID = int.parse(element["id"].toString());
      }
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }

    return bankID;
  }

  Future<int> getCurrencyID(String name, int bankID, Function onError) async {
    Response response;
    Dio dio = new Dio();
    int currencyID;

    try {
      response = await dio.get(
          "${StringConfigs.baseApiUrl}/exchange/coins/?abbr=$name&bank=$bankID");

      for (var element in response.data) {
        currencyID = int.parse(element["id"].toString());
      }
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }

    return currencyID;
  }
}
