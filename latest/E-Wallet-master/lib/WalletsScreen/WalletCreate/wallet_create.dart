import 'package:e_wallet/BankInfoScreen/bloc/bank_info_bloc.dart';
import 'package:e_wallet/BankPageScreen/bloc/bank_page_bloc.dart';
import 'package:e_wallet/MainScreen/MainScreenComponents/Network_Indicator/network_indicator.dart';
import 'package:e_wallet/Notifications/notifications_flushbar/notifications_flushbar.dart';
import 'package:e_wallet/WalletsScreen/WalletCreate/bloc/wallet_create_bloc.dart';
import 'package:e_wallet/WalletsScreen/WalletCreate/bloc/wallet_create_states.dart';
import 'package:e_wallet/models/bank.dart';
import 'package:e_wallet/rest/bank_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WalletCreate extends StatefulWidget {
  @override
  WalletCreateState createState() => WalletCreateState();
}

class WalletCreateState extends State<WalletCreate> with WalletCreateEvent {
  WalletCreateBloc _walletCreateBloc;
  List<String> bankNames;
  List<Bank> banks;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String defaultBank;
  String defaultCurrency = "USD";

  @override
  void initState() {
    _walletCreateBloc = WalletCreateBloc(this);
    _walletCreateBloc.loadAvailableBanks();
    Future.delayed(Duration(milliseconds: 900)).then((value) {
      defaultBank = _walletCreateBloc.banksName[0];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Color(0xffE1E9E5),
          appBar: AppBar(
            title: Center(
                child: Column(
              children: [
                SizedBox(height: 10),
                Text("Create Wallet",
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
          body: BlocBuilder<WalletCreateBloc, WalletCreateStates>(
            cubit: _walletCreateBloc,
            builder: (context, state) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          "Please Introduce Wallet Parameters",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text("Choose bank"),
                              DropdownButton<String>(
                                value: defaultBank,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String data) {
                                  defaultBank = data;
                                  _walletCreateBloc.bankName = defaultBank;
                                  _walletCreateBloc.getBankID();
                                  _walletCreateBloc.currenciesName = [];
                                  _walletCreateBloc.loadAvailableCurrencies();
                                  _walletCreateBloc.refreshWalletPage();
                                },
                                items: _walletCreateBloc.banksName
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                          SizedBox(width: 30),
                          Column(
                            children: [
                              NetworkIndicator(),
                              NotificationsFlushbar(),
                              Text("Choose currency"),
                              DropdownButton<String>(
                                  value: defaultCurrency,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String data) {
                                    defaultCurrency = data;
                                    _walletCreateBloc.currencyName = data;

                                    _walletCreateBloc.getCurrencyID();
                                    _walletCreateBloc.refreshWalletPage();
                                  },
                                  items: _walletCreateBloc.currenciesName
                                      .map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList())
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 40),
                      RaisedButton(
                          child: Text(
                            "Create Wallet",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () {
                            _walletCreateBloc.createWallet();

                            Future.delayed(Duration(seconds: 1)).then((value) {
                              Navigator.of(context).pop(_walletCreateBloc.wallet);
                            });

                          })
                    ],
                  ),
                ),
              );
            },
          )),
      // ignore: missing_return
      onWillPop: () {
      },
    );
  }

  @override
  void onError(errorText) {
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

abstract class WalletCreateEvent {
  void onError(var errorText);
}
