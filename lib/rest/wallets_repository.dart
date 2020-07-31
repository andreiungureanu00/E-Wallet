import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/models/coin.dart';
import 'package:e_wallet/models/transaction.dart';
import 'package:e_wallet/models/wallet.dart';
import 'package:e_wallet/rest/StringConfigs.dart';
import 'package:e_wallet/rest/auth_repository.dart';

class WalletsRepository {
  static final WalletsRepository _singleton = new WalletsRepository._internal();

  factory WalletsRepository() {
    return _singleton;
  }

  WalletsRepository._internal();

  Future<List<Wallet>> getWallets() async {
    var response;
    List<Wallet> wallets = List();
    Dio dio = new Dio();
    String accessToken;

    accessToken = CurrentUserSingleton().getAccessToken();

    dio.interceptors.add(DioCacheManager(
            CacheConfig(baseUrl: "${StringConfigs.baseApiUrl}/wallets/"))
        .interceptor);

    response = await dio.get("${StringConfigs.baseApiUrl}/wallets/",
        options: buildCacheOptions(Duration(days: 7),
            maxStale: Duration(days: 10),
            forceRefresh: true,
            options: Options(headers: {
              HttpHeaders.authorizationHeader: "Bearer $accessToken"
            })));

    for (var i in response.data) {
      Wallet wallet = Wallet.fromJson(i);
      wallet.currencyName = await getCurrencyById(wallet.currency);
      wallets.add(wallet);
    }

    return wallets;
  }

  Future<String> getCurrencyById(int currencyId) async {
    String coinName = "";
    Dio dio = new Dio();
    String accessToken;

    dio.interceptors.add(DioCacheManager(CacheConfig(
            baseUrl:
                "${StringConfigs.baseApiUrl}/banks/coin/?format=json&page_size=20"))
        .interceptor);

    accessToken = CurrentUserSingleton().getAccessToken();

    Response response = await dio.get(
        "${StringConfigs.baseApiUrl}/banks/coin/?format=json&page_size=20");

    for (var i in response.data["results"]) {
      Coin coin = Coin.fromJson(i);
      if (coin.id == currencyId) coinName = coin.abbr;
    }

    return coinName;
  }

  Future<List<Transaction>> getTransactions(int walletID) async {
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
      transaction.currencyName = await getCurrencyById(transaction.currency);
      transactions.add(transaction);
    }

    return transactions;
  }

  Future<void> createWallet(int currencyID) async {
    String accessToken;
    Dio dio = new Dio();

    accessToken = CurrentUserSingleton().getAccessToken();

    Map<String, dynamic> body = {"currency": currencyID};
    String urlWallet = "${StringConfigs.baseApiUrl}/wallets/";
    var response;
    response = await dio.post(urlWallet,
        data: body,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"}));
    print(response.data.toString());
  }

  Future<void> newTransaction(int walletID, double amount, int currency) async {
    Dio dio = new Dio();
    String accessToken;

    Map<String, dynamic> body = {"amount": amount, "currency": currency};
    accessToken = CurrentUserSingleton().getAccessToken();

    print(accessToken);
    print("currency = " + currency.toString());

    String urlTransaction =
        "${StringConfigs.baseApiUrl}/wallets/$walletID/transactions/";

    var response = await dio.post(urlTransaction,
        data: body,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"}));

    print(response.data.toString());
  }
}
