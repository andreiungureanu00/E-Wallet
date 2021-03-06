
import 'package:e_wallet/AuthScreen/LoginScreen/login_page_screen.dart';
import 'package:e_wallet/MainScreen/MainScreenComponents/Network_Indicator/network_indicator.dart';
import 'package:e_wallet/MainScreen/MainScreenComponents/WalletCardsList/bloc/wallet_cards_list_bloc.dart';
import 'package:e_wallet/MainScreen/MainScreenComponents/WalletCardsList/wallet_cards_list.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_bloc.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_state.dart';
import 'package:e_wallet/Notifications/notifications_flushbar/notifications_flushbar.dart';
import 'package:e_wallet/Notifications/notifications_list/notifications_list_page.dart';
import 'package:e_wallet/WalletsScreen/WalletCreate/wallet_create.dart';
import 'package:e_wallet/models/user.dart';
import 'package:e_wallet/rest/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'MainScreenComponents/Left_Menu/left_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with MainScreenEvents {
  int counter = 0;
  MainScreenBloc _mainScreenBloc;
  WalletCardsListBloc _walletCardsListBloc;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  CurrentUser currentUser;
  bool visibility;

  @override
  void initState() {
    _mainScreenBloc = MainScreenBloc(this);
    _walletCardsListBloc = WalletCardsListBloc(this);
    _mainScreenBloc.loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Center(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 60),
                      Text("Wallet Page",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20))
                    ],
                  )
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
            IconButton(
              color: Colors.black,
              icon: Icon(FontAwesomeIcons.bell),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Notifications(),
                    ));
              },
            ),
          ],
          backgroundColor: Colors.grey[600],
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
          backgroundColor: Colors.blueGrey[800],
        ),
      ),
    );
  }

  Widget pageBody() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/MainScreenBackground.jpg"),
            fit: BoxFit.fill),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          NetworkIndicator(),
          NotificationsFlushbar(),
          BlocBuilder<MainScreenBloc, MainScreenState>(
            cubit: _mainScreenBloc,
            builder: (context, state) {
              return Column(
                children: [
                  WalletCardsList(),
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
                                onTap: () async {
                                  _walletCardsListBloc.createdWallet =
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WalletCreate(),
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
                                  colors: [
                                    Colors.green,
                                    Colors.blueGrey,
                                  ])),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Column(children: [
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
                          ]),
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Colors.green, Colors.blueGrey])),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              );
            },
          ),
        ],
      )),
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
  void loadWallets() {}

}

abstract class MainScreenEvents {
  void onError(var errorText);

  void loadWallets();
}
