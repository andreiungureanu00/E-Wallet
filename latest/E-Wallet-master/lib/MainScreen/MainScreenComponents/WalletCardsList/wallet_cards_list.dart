import 'package:e_wallet/MainScreen/MainScreenComponents/WalletCardsList/bloc/wallet_cards_list_bloc.dart';
import 'package:e_wallet/MainScreen/MainScreenComponents/WalletCardsList/bloc/wallet_cards_list_states.dart';
import 'package:e_wallet/MainScreen/main_screen.dart';
import 'package:e_wallet/WalletsScreen/WalletTransactions/wallet_transactions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WalletCardsList extends StatefulWidget {
  @override
  WalletCardsListState createState() => WalletCardsListState();
}

class WalletCardsListState extends State<WalletCardsList>
    with MainScreenEvents {
  ScrollController scrollController;
  WalletCardsListBloc _cardsListBloc;

  @override
  void initState() {
    _cardsListBloc = WalletCardsListBloc(this);
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    _cardsListBloc.loadWallets();
    super.initState();
  }

  _scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {}
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {}
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) if (scrollController
            .position.userScrollDirection ==
        ScrollDirection.reverse) {}
  }

  _moveUp() {
    scrollController.animateTo(
        scrollController.offset + MediaQuery.of(context).size.width,
        curve: Curves.linear,
        duration: Duration(milliseconds: 700));
  }

  _moveDown() {
    scrollController.animateTo(
        scrollController.offset - MediaQuery.of(context).size.width,
        curve: Curves.linear,
        duration: Duration(milliseconds: 700));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCardsListBloc, WalletCardsListStates>(
      cubit: _cardsListBloc,
      builder: (context, state) {
        if (_cardsListBloc.wallets == null) {
          return CircularProgressIndicator();
        }
        else return SizedBox(
          height: 290.0,
          child: ListView.builder(
            primary: false,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            shrinkWrap: true,
            itemCount: _cardsListBloc.wallets.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 10),
                          InkWell(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 20,
                                        ),
                                        child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "WALLET_ID : " +
                                                      _cardsListBloc
                                                          .wallets[index].id
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(width: 60),
                                                IconButton(
                                                    iconSize: 20,
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      _cardsListBloc.walletID =
                                                          _cardsListBloc
                                                              .wallets[index].id;
                                                      _cardsListBloc.deleteWallet();
                                                    },
                                                    icon: Visibility(
                                                      visible: _cardsListBloc
                                                          .wallets[index]
                                                          .balance ==
                                                          0
                                                          ? true
                                                          : false,
                                                      child: Icon(
                                                        FontAwesomeIcons.trash,
                                                      ),
                                                    ))
                                              ],
                                            ))),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              iconSize: 50,
                                              icon: Visibility(
                                                child: Icon(
                                                    FontAwesomeIcons.caretLeft),
                                                visible: false,
                                              ),
                                              onPressed: () {
                                                if (_cardsListBloc.counter > 0)
                                                  _cardsListBloc.counter--;
                                                _moveDown();
                                              },
                                            ),
                                            Text(
                                              _cardsListBloc.updatedWallet ==
                                                  null
                                                  ? "Balance: " +
                                                  _cardsListBloc
                                                      .wallets[index]
                                                      .balance
                                                      .round()
                                                      .toString() +
                                                  " " +
                                                  _cardsListBloc
                                                      .wallets[index]
                                                      .currencyName
                                                  : "Balance: " +
                                                  _cardsListBloc
                                                      .updatedWallet.balance
                                                      .round()
                                                      .toString() +
                                                  " " +
                                                  _cardsListBloc
                                                      .wallets[index]
                                                      .currencyName,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight:
                                                  FontWeight.normal),
                                            ),
                                            IconButton(
                                              iconSize: 50,
                                              icon: Visibility(
                                                child: Icon(FontAwesomeIcons
                                                    .caretRight),
                                                visible: false,
                                              ),
                                              onPressed: () {
                                                _cardsListBloc.counter++;
                                                if (_cardsListBloc.counter >
                                                    _cardsListBloc
                                                        .wallets.length -
                                                        1)
                                                  _cardsListBloc.counter = 0;
                                                _moveUp();
                                              },
                                            ),
                                          ],
                                        )),
                                    Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Value Buy : " +
                                                            _cardsListBloc
                                                                .wallets[index]
                                                                .value_buy
                                                                .round()
                                                                .toString(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Value Sell : " +
                                                            _cardsListBloc
                                                                .wallets[index]
                                                                .value_sell
                                                                .round()
                                                                .toString(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 20),
                                            Column(
                                              children: [
                                                Text(
                                                  "Profit: " +
                                                      _cardsListBloc
                                                          .wallets[index].profit
                                                          .toStringAsFixed(3) +
                                                      " " +
                                                      _cardsListBloc
                                                          .wallets[index]
                                                          .currencyName,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 220,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [Colors.green, Colors.blueGrey],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  FlatButton(
                    child: Text(
                      "Transactions",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    onPressed: () async {
                      _cardsListBloc.updatedWallet = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WalletTransactions(
                                _cardsListBloc.wallets[index].id,
                                _cardsListBloc.wallets[index].currency),
                          ));

                      _cardsListBloc.updateWalletBalance();
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  void loadWallets() {
    _cardsListBloc.loadWallets();
  }

  @override
  void onError(errorText) {
  }

  @override
  void onWalletDelete(walletID) {
  }

  @override
  void onFCMTokenGot() {
  }

  @override
  void onNotificationReceived() {
  }

  @override
  void loadNotifications() {
    // TODO: implement loadNotifications
  }
}


