import 'package:e_wallet/AuthScreen/LoginScreen/login_page_screen.dart';
import 'package:e_wallet/MainScreen/MainScreenComponents/left_menu.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_bloc.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_state.dart';
import 'package:e_wallet/WalletsScreen/WalletCreate/wallet_create.dart';
import 'package:e_wallet/WalletsScreen/WalletTransactions/wallet_transactions.dart';
import 'package:e_wallet/models/user.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

// snack bar windows for exceptions

class _MainScreenState extends State<MainScreen> with MainScreenEvents {
  ScrollController scrollController;
  int counter = 0;
  MainScreenBloc _mainScreenBloc;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  User currentUser;


  @override
  void initState() {
    _mainScreenBloc = MainScreenBloc(this);
    _mainScreenBloc.loadWallets();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    _mainScreenBloc.reloadWallets();
    super.initState();
  }

  _scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {}
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange)

    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {}
  }

  _moveUp() {
    scrollController.animateTo(scrollController.offset + MediaQuery.of(context).size.width,
        curve: Curves.linear, duration: Duration(milliseconds: 700));
  }

  _moveDown() {
    scrollController.animateTo(scrollController.offset - MediaQuery.of(context).size.width,
        curve: Curves.linear, duration: Duration(milliseconds: 700));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyLoginPage(),
                  ));
            },
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
      drawer: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.white, Colors.black])),
        child: Drawer(child: LeftMenu(_mainScreenBloc)),
      ),
      body: pageBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.wallet),
            title: Text("Wallet"),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userAlt),
            title: Text("Account"),
          ),
        ],
        currentIndex: 0,
        onTap: (i) {},
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 20, 0, 100),
      ),
    );
  }

  Widget pageBody() {
    return Container(
      color: Color(0xffE1E9E5),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          BlocBuilder<MainScreenBloc, MainScreenState>(
            bloc: _mainScreenBloc,
            builder: (context, state) {
              if (_mainScreenBloc.wallets != null) {
                return Column(
                  children: [
                    SizedBox(
                      height: 270.0,
                      child: ListView.builder(
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: _mainScreenBloc.wallets.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        child: walletCard(
                                            _mainScreenBloc.wallets,
                                            index,
                                            _mainScreenBloc),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              FlatButton(
                                child: Text(
                                  "Transactions",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WalletTransactions(
                                                _mainScreenBloc
                                                    .wallets[index].id,
                                                _mainScreenBloc
                                                    .wallets[index].currency),
                                      ));
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Card(
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(height: 3),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Wallet Settings",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(width: 130),
                            Image.network(
                              "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmaxcdn.icons8.com%2FShare%2Ficon%2Fnolan%2FFinance%2Fbank_cards1600.png&f=1&nofb=1",
                              width: 50,
                            )
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.elliptical(5, 5),
                                right: Radius.elliptical(5, 5))),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                InkWell(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Add Wallet",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WalletCreate(),
                                        ));
                                  },
                                ),
                                SizedBox(height: 20)
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [Colors.pink, Colors.deepOrange])),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        child: Text(
                                          "Make a payment",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      onTap: () {},
                                    )
                                  ],
                                ),
                                SizedBox(height: 20)
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [Colors.green, Colors.yellow])),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 120),
                  ],
                );
              } else {
                return Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 3),
                    Container(child: CircularProgressIndicator()),
                  ],
                );
              }
            },
          ),
        ],
      )),
    );
  }

  Widget walletCard(data, index, bloc) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Color(0xffE1E9E5)),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "WALLET_ID : " + data[index].id.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 60),
                      IconButton(
                        iconSize: 20,
                        color: Colors.red, onPressed: () {
                          WalletsRepository().deleteWallet(data[index].id, onError);
                      }, icon: Visibility(
                        visible: data[index].balance == 0 ? true : false,
                        child: Icon(
                          FontAwesomeIcons.trash,
                        ),
                      )
                      )
                    ],
                  )
                )),
            Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      iconSize: 50,
                      icon: Icon(FontAwesomeIcons.caretLeft),
                      onPressed: () {
                        if (counter > 0) counter--;
                        _moveDown();
                      },
                    ),
                    Text(
                      "Balance: " +
                          data[index].balance.round().toString() +
                          " " +
                          data[index].currencyName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                    IconButton(
                      iconSize: 50,
                      icon: Icon(FontAwesomeIcons.caretRight),
                      onPressed: () {
                        counter++;
                        if (counter > bloc.wallets.length - 1) counter = 0;
                        _moveUp();
                      },
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text(
                                "Value Buy : " +
                                    data[index].value_buy.round().toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "Value Sell : " +
                                    data[index].value_sell.round().toString(),
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
                              data[index].profit.toStringAsFixed(3) +
                              " " +
                              data[index].currencyName,
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
            colors: [Colors.red, Colors.blue],
          ),
        ),
      ),
    );
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

  @override
  void onWalletDelete(walletID) {

  }
}

abstract class MainScreenEvents {
  void onError(var errorText);
  void onWalletDelete(var walletID);
}
