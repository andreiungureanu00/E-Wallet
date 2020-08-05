import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/WalletsScreen/TransactionCreate/bloc/transaction_create_bloc.dart';
import 'package:e_wallet/WalletsScreen/TransactionCreate/bloc/transaction_create_states.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionsCreate extends StatefulWidget {
  final int walletID;
  final int currency;

  TransactionsCreate(this.walletID, this.currency);

  @override
  TransactionsCreateState createState() =>
      TransactionsCreateState(walletID, currency);
}

class TransactionsCreateState extends State<TransactionsCreate> with OnError {
  int walletID;
  int currency;
  var response;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TransactionCreateBloc _transactionCreateBloc;

  TransactionsCreateState(this.walletID, this.currency);

  @override
  void initState() {
    _transactionCreateBloc = TransactionCreateBloc(walletID, currency, this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
        body: BlocBuilder<TransactionCreateBloc, TransactionCreateStates>(
          bloc: _transactionCreateBloc,
          builder: (context, state) {
            return SingleChildScrollView(
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
                          _transactionCreateBloc.amount = double.parse(value);
                        },
                        decoration: InputDecoration(
                            hintText: "Enter amount",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
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
                          _transactionCreateBloc.createTransaction();
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  @override
  void onError(var errorText) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(errorText),
        action: SnackBarAction(
          label: 'Click Me',
          onPressed: () {},
        ),
      ),
    );
  }
}

abstract class OnError {
  void onError(var errorText);
}
