import 'package:e_wallet/MainScreen/MainScreenComponents/Network_Indicator/network_indicator.dart';
import 'package:e_wallet/Notifications/notifications_flushbar/notifications_flushbar.dart';
import 'package:e_wallet/WalletsScreen/TransactionCreate/transaction_create.dart';
import 'package:e_wallet/WalletsScreen/WalletTransactions/bloc/wallet_transactions_bloc.dart';
import 'package:e_wallet/WalletsScreen/WalletTransactions/bloc/wallet_transactions_states.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WalletTransactions extends StatefulWidget {
  final int walletID;
  final int currency;

  WalletTransactions(this.walletID, this.currency);

  @override
  WalletTransactionsState createState() =>
      WalletTransactionsState(walletID, currency);
}

class WalletTransactionsState extends State<WalletTransactions>
    with WalletTransactionsEvent {
  final int walletID;
  final int currency;
  WalletTransactionsBloc _walletTransactionsBloc;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  WalletTransactionsState(this.walletID, this.currency);

  @override
  void initState() {
    _walletTransactionsBloc = WalletTransactionsBloc(walletID, this);
    _walletTransactionsBloc.loadWalletTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Center(
              child: Column(
            children: [
              NetworkIndicator(),
              NotificationsFlushbar(),
              SizedBox(height: 10),
              FlatButton(
                child: Text(
                  "New Transaction",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                onPressed: () async {
                  _walletTransactionsBloc.createdTransaction =
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TransactionsCreate(walletID, currency),
                          ));
                  _walletTransactionsBloc.addTransaction();
                },
              )
            ],
          )),
          actions: <Widget>[
            IconButton(
              color: Colors.black,
              icon: Icon(FontAwesomeIcons.user),
              onPressed: () {},
            ),
          ],
          elevation: 0,
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
        body: BlocBuilder<WalletTransactionsBloc, WalletTransactionsStates>(
          cubit: _walletTransactionsBloc,
          builder: (context, state) {
            if (_walletTransactionsBloc.transactions == null) {
              return Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 3),
                  Container(child: CircularProgressIndicator())
                ],
              );
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _walletTransactionsBloc.transactions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child: Icon(
                                          _walletTransactionsBloc
                                              .transactions[index].amount >
                                              0
                                              ? FontAwesomeIcons.angleDown
                                              : FontAwesomeIcons.angleUp,
                                          color: _walletTransactionsBloc
                                              .transactions[index].amount >
                                              0
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          _walletTransactionsBloc
                                              .transactions[index].amount >
                                              0
                                              ? "+" +
                                              _walletTransactionsBloc
                                                  .transactions[index].amount
                                                  .round()
                                                  .toString() +
                                              " " +
                                              _walletTransactionsBloc
                                                  .transactions[index]
                                                  .currencyName
                                              : "-" +
                                              _walletTransactionsBloc
                                                  .transactions[index].amount
                                                  .round()
                                                  .toString() +
                                              " " +
                                              _walletTransactionsBloc
                                                  .transactions[index]
                                                  .currencyName,
                                          style: TextStyle(
                                              color: _walletTransactionsBloc
                                                  .transactions[index]
                                                  .amount >
                                                  0
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
                      ),
                    ),
                    FlatButton(
                      child: Text("Clear Transactions History"),
                      onPressed: () {
                        _walletTransactionsBloc.clearHistory();
                      },
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
      // ignore: missing_return
      onWillPop: () {
        _walletTransactionsBloc.updateWallet();
      },
    );
  }

  @override
  void onError(errorText) {
    print(errorText);
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

  @override
  void walletUpdated() {
    Navigator.of(context).pop(_walletTransactionsBloc.updatedWallet);
  }
}

abstract class WalletTransactionsEvent {
  void onError(var errorText);

  void walletUpdated();
}
