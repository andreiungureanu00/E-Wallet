import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/models/coin.dart';
import 'package:e_wallet/models/transaction.dart';
import 'package:e_wallet/models/wallet.dart';
import 'package:e_wallet/rest/StringConfigs.dart';

// internet connectivity

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
    String errorMessage;

    accessToken = CurrentUserSingleton().getAccessToken();

    dio.interceptors.add(DioCacheManager(
            CacheConfig(baseUrl: "${StringConfigs.baseApiUrl}/wallets/"))
        .interceptor);

    try {
      response = await dio.get("${StringConfigs.baseApiUrl}/wallets/",
          options: buildCacheOptions(Duration(days: 7),
              maxStale: Duration(days: 10),
              forceRefresh: true,
              options: Options(
                  headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"})));

      print(response.data.toString());

      for (var i in response.data) {
        Wallet wallet = Wallet.fromJson(i);
        wallet.currencyName = await getCurrencyById(wallet.currency, onError);
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

  Future<List<Transaction>> getTransactions(int walletID, Function onError) async {
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

      for (var i in response.data) {
        Transaction transaction = Transaction.fromJson(i);
        transaction.currencyName = await getCurrencyById(transaction.currency, onError);
        transactions.add(transaction);
      }
    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }

    return transactions;
  }

  Future<void> createWallet(int currencyID, Function onError) async {
    String accessToken;
    Dio dio = new Dio();
    var response;
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
          },
          contentType: 'application/json'));

      if (response.data != null) {
      }

    } catch (exception) {
      if (exception is DioError) {
        onError(exception.error);
      }
    }
    return response.data;
  }

  Future<void> newTransaction(int walletID, double amount, int currency, Function onError) async {
    Dio dio = new Dio();
    String accessToken;

    Map<String, dynamic> body = {"amount": amount, "currency": currency};
    accessToken = CurrentUserSingleton().getAccessToken();

    print(accessToken);
    print("currency = " + currency.toString());

    String urlTransaction =
        "${StringConfigs.baseApiUrl}/wallets/$walletID/transactions/";

    try {
      var response = await dio.post(urlTransaction,
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
  }
}
