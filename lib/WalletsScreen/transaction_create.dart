import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionsCreate extends StatefulWidget {
  final int walletID;
  final int currency;

  TransactionsCreate(this.walletID, this.currency);

  @override
  TransactionsCreateState createState() =>
      TransactionsCreateState(walletID, currency);
}

class TransactionsCreateState extends State<TransactionsCreate> {
  int walletID;
  int currency;

  TransactionsCreateState(this.walletID, this.currency);

  String currencyName;
  int currencyID;
  double amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE1E9E5),
        appBar: AppBar(
          title: Center(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text("Create Transaction",
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                      "Please Introduce Transaction Parameters",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      amount = double.parse(value);
                    },
                    decoration: InputDecoration(
                        hintText: "Enter amount",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ),
                  SizedBox(height: 40),
                  RaisedButton(
                    child: Text(
                      "New Transaction",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      print(walletID.toString() + " " + amount.toString() + " " + currency.toString());
                      WalletsRepository().newTransaction(walletID, amount, currency);
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
