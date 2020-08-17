import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/models/available_currency.dart';
import 'package:e_wallet/models/coin.dart';
import 'package:e_wallet/models/transaction.dart';
import 'package:e_wallet/models/wallet.dart';
import 'package:e_wallet/rest/StringConfigs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalletsRepository {
  static final WalletsRepository _singleton = new WalletsRepository._internal();

  factory WalletsRepository() {
    return _singleton;
  }

  WalletsRepository._internal();

  Future<List<Wallet>> getWallets(Function onError) async {
    Response response;
    List<Wallet> wallets = List();
    Dio dio = new Dio();
    String accessToken;

    accessToken = CurrentUserSingleton().getAccessToken();

    dio.interceptors.add(DioCacheManager(
            CacheConfig(baseUrl: "${StringConfigs.baseApiUrl}/wallets/"))
        .interceptor);

    try {
      response = await dio.get("${StringConfigs.baseApiUrl}/wallets/",
          options: buildCacheOptions(Duration(days: 7),
              maxStale: Duration(days: 10),
              forceRefresh: true,
              options: Options(headers: {
                HttpHeaders.authorizationHeader: "Bearer $accessToken"
              })));

      for (var element in response.data) {
        Wallet wallet = Wallet(
            element["id"],
            element["user"],
            element["currency"]["id"],
            element["balance"],
            element["value_buy"],
            element["value_sell"],
            element["profit"],
            element["currency"]["abbr"]);
        wallets.add(wallet);
      }
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }

    return wallets;
  }

  Future<String> getCurrencyById(int currencyId, Function onError) async {
    String coinName = "";
    Dio dio = new Dio();
    String accessToken;

    dio.interceptors.add(DioCacheManager(CacheConfig(
            baseUrl:
                "${StringConfigs.baseApiUrl}/banks/coin/?format=json&page_size=20"))
        .interceptor);

    accessToken = CurrentUserSingleton().getAccessToken();

    try {
      Response response = await dio.get(
          "${StringConfigs.baseApiUrl}/banks/coin/?format=json&page_size=20");

      for (var i in response.data["results"]) {
        Coin coin = Coin.fromJson(i);
        if (coin.id == currencyId) coinName = coin.abbr;
      }
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }

    return coinName;
  }

  Future<List<Transaction>> getTransactions(
      int walletID, Function onError) async {
    var response;
    List<Transaction> transactions;
    Dio dio = new Dio();
    String accessToken;

    accessToken = CurrentUserSingleton().getAccessToken();
    transactions = List();
    dio.interceptors.add(DioCacheManager(CacheConfig(
            baseUrl:
                "${StringConfigs.baseApiUrl}/wallets/$walletID/transactions/"))
        .interceptor);

    try {
      response = await dio.get(
          "${StringConfigs.baseApiUrl}/wallets/$walletID/transactions/",
          options: buildCacheOptions(Duration(days: 7),
              maxStale: Duration(days: 10),
              forceRefresh: true,
              options: Options(headers: {
                HttpHeaders.authorizationHeader: "Bearer $accessToken"
              })));

      for (var element in response.data) {
        Transaction transaction = Transaction(element["id"], element["amount"], element["wallet"], element["currency"]["id"], element["rate"], element["currency"]["abbr"]);
        print("transaction abbr = " + transaction.currencyName.toString());
        transactions.add(transaction);
      }
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }

    return transactions;
  }

  Future<Response> createWallet(int currencyID, Function onError) async {
    String accessToken;
    Dio dio = new Dio();
    Response response;
    String urlWallet = "${StringConfigs.baseApiUrl}/wallets/";
    accessToken = CurrentUserSingleton().getAccessToken();

    Map<String, dynamic> body = {"currency": currencyID};

    try {
      response = await dio.post(urlWallet,
          data: body,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $accessToken"
          }));

      print(response.data.toString());

    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }

    return response;
  }

  Future<dynamic> deleteWallet(int walletId, Function onError) async {
    String accessToken;
    Dio dio = new Dio();
    var response;
    String urlWallet = "${StringConfigs.baseApiUrl}/wallets/$walletId/";
    accessToken = CurrentUserSingleton().getAccessToken();
    print(urlWallet);

    try {
      response = await dio.delete(urlWallet,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $accessToken",
          }, contentType: 'application/json'));

      if (response.data != null) {
        print(response.data.toString());
        Fluttertoast.showToast(
            msg: "Wallet Deleted Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blueAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }
    return response.data;
  }

  Future<dynamic> newTransaction(
      int walletID, double amount, int currency, Function onError) async {
    Dio dio = new Dio();
    String accessToken;

    Map<String, dynamic> body = {"amount": amount, "currency": currency};
    accessToken = CurrentUserSingleton().getAccessToken();

    String urlTransaction =
        "${StringConfigs.baseApiUrl}/wallets/$walletID/transactions/";

    try {
      var response = await dio.post(urlTransaction,
          data: body,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $accessToken"
          }));

      return response.data;
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }
  }

  Future<Wallet> getUpdatedWallet(int walletID, Function onError) async {
    var response;
    Dio dio = new Dio();
    String accessToken;
    Wallet wallet;

    accessToken = CurrentUserSingleton().getAccessToken();

    try {
      response = await dio.get("${StringConfigs.baseApiUrl}/wallets/$walletID",
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $accessToken"
          }));

      for (var i in response.data) {
        wallet = Wallet.fromJson(i);
      }

      print("in getUpdatedWallet " + wallet.balance.toString());
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }

    return wallet;
  }

  Future<dynamic> getPossibleCurrencies(int bankID, Function onError) async {
    var response;
    List<AvailableCurrency> currencies;
    Dio dio = new Dio();
    String accessToken;

    accessToken = CurrentUserSingleton().getAccessToken();
    currencies = List();

    try {
      response = await dio.get(
          "${StringConfigs.baseApiUrl}/wallets/options/currencies/$bankID",
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $accessToken"
          }));

      for (var i in response.data) {
        AvailableCurrency currency = AvailableCurrency.fromJson(i);
        currencies.add(currency);
      }
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }

    return currencies;
  }
}
