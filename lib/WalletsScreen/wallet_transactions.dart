import 'dart:io';

import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/WalletsScreen/transaction_create.dart';
import 'package:e_wallet/models/coin.dart';
import 'package:e_wallet/models/transaction.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WalletTransactions extends StatefulWidget {
  final int walletID;
  final int currency;

  WalletTransactions(this.walletID, this.currency);

  @override
  WalletTransactionsState createState() => WalletTransactionsState(walletID, currency);
}

class WalletTransactionsState extends State<WalletTransactions> {

  final int walletID;
  final int currency;

  WalletTransactionsState(this.walletID, this.currency);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Column(
              children: [
                SizedBox(height: 10),
                Text("Wallet Page",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20))
              ],
            )),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            icon: Icon(FontAwesomeIcons.user),
            onPressed: () {},
          ),
        ],
        backgroundColor: Color(0xffE1E9E5),
        brightness: Brightness.dark,
        textTheme: TextTheme(
          headline5: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              FutureBuilder(
                future: WalletsRepository().getTransactions(walletID),
                builder: (BuildContext context, AsyncSnapshot snapShot) {
                  if (snapShot.data == null) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapShot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Card(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Icon(
                                        snapShot.data[index].amount > 0
                                            ? FontAwesomeIcons.angleDown
                                            : FontAwesomeIcons.angleUp,
                                        color: snapShot.data[index].amount > 0
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(height: 3),

                                    ],
                                  ),
                                  SizedBox(width: 170),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        snapShot.data[index].amount > 0
                                            ? "+" +
                                            snapShot.data[index].amount
                                                .round()
                                                .toString() +
                                            " " +
                                            snapShot.data[index].currencyName
                                            : "-" +
                                            snapShot.data[index].amount
                                                .round()
                                                .toString() +
                                            " " +
                                            snapShot.data[index].currencyName,
                                        style: TextStyle(
                                            color: snapShot.data[index].amount > 0
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 22),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  )
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.elliptical(5, 5),
                                      right: Radius.elliptical(5, 5))),
                            )
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              FlatButton(
                child: Text(
                  "New Transaction",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => TransactionsCreate(walletID, currency),
                  ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}