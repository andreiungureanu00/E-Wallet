import 'package:e_wallet/BankPageScreen/bank_page_screen.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_bloc.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_state.dart';
import 'package:e_wallet/WalletsScreen/wallet_create.dart';
import 'package:e_wallet/WalletsScreen/wallet_transactions.dart';
import 'package:e_wallet/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  final User currentUser;

  MainScreen(this.currentUser);

  @override
  _MainScreenState createState() => _MainScreenState(this.currentUser);
}

class _MainScreenState extends State<MainScreen> {
  final User currentUser;

  ScrollController scrollController;
  int counter = 0;
  MainScreenBloc _mainScreenBloc;

  _MainScreenState(this.currentUser);

  @override
  void initState() {
    _mainScreenBloc = MainScreenBloc();
    _mainScreenBloc.loadWallets();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {}
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {}
  }

  _moveUp(int index) {
    scrollController.animateTo(index * 400.0,
        duration: new Duration(seconds: 2), curve: Curves.ease);
    index = 0;
  }

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
      drawer: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.white, Colors.black])),
        child: Drawer(child: leftMenu()),
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
                return SizedBox(
                  height: 270.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
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
                                        _mainScreenBloc.wallets, index),
                                    onTap: () {
//

                                      counter++;
                                      if (counter >
                                          _mainScreenBloc.wallets.length - 1)
                                        counter = 0;
                                      _moveUp(counter);
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                          FlatButton(
                            child: Text(
                              "Transactions",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WalletTransactions(
                                        _mainScreenBloc.wallets[index].id,
                                        _mainScreenBloc
                                            .wallets[index].currency),
                                  ));
                            },
                          ),
                        ],
                      );
                    },
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
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
                  SizedBox(width: 170),
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
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
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
      )),
    );
  }

  Widget leftMenu() {
    return ListView(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.white70, Colors.red])),
          child: UserAccountsDrawerHeader(
            accountEmail: Text(currentUser.email),
            accountName: Text(currentUser.username),
            currentAccountPicture: CircleAvatar(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  fit: BoxFit.fill,
                  image: NetworkImage(currentUser.photoUrl),
                ),
              ),
            ),
          ),
        ),
        ListTile(
          title: Text("Wallets"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MainScreen(currentUser)));
          },
        ),
        ListTile(
          title: Text("Banks"),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => BankPage()));
          },
        ),
        ListTile(
          title: Text("Help"),
          onTap: () {},
        ),
      ],
    );
  }

  Widget walletCard(data, index) {
    return Container(
      width: 400,
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
              child: Text(
                "WALLET_ID : " + data[index].id.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                "Balance: " +
                    data[index].balance.round().toString() +
                    " " +
                    data[index].currencyName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                alignment: Alignment.centerLeft,
                child: Row(
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
                    SizedBox(width: 50),
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
            SizedBox(
              height: 20,
            )
          ],
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 25,
        ),
        width: MediaQuery.of(context).size.width,
        height: 200,
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
}
