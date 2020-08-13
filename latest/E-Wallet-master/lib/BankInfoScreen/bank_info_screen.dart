import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:e_wallet/BankInfoScreen/bloc/bank_info_bloc.dart';
import 'package:e_wallet/BankInfoScreen/bloc/bank_info_states.dart';
import 'package:e_wallet/ReportsScreen/reports_screen.dart';
import 'package:e_wallet/models/bank.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class BankInfoPage extends StatefulWidget {
  Bank bank;

  BankInfoPage(this.bank);

  @override
  _BankInfoPageState createState() => _BankInfoPageState(bank);
}

class _BankInfoPageState extends State<BankInfoPage> with OnError {
  Bank bank;
  ScrollController scrollController;
  int pageNumber;

  // ignore: non_constant_identifier_names
  int nr_elements;

  // ignore: non_constant_identifier_names
  int page_size;
  BankInfoBloc _bankInfoBloc;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  _BankInfoPageState(this.bank);

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {}
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {}
  }

  void round(double number) {
    int decimals = 2;
    int fac = pow(10, decimals);
    number = (number * fac).round() / fac;
  }

  @override
  void initState() {
    pageNumber = 1;
    page_size = 10;
    _bankInfoBloc = BankInfoBloc(bank, this);
    _bankInfoBloc.loadBankInfo();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Center(
            child: Column(
          children: [
            SizedBox(height: 5),
            Text("Bank Coins",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            Text(bank.registered_name,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25))
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
        backgroundColor: Colors.transparent,
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
      body: Container(
          margin: EdgeInsets.only(top: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "Curs valutar",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontFamily: 'RobotMono',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TyperAnimatedTextKit(
                      text: [
                        "Cumpărare",
                      ],
                      speed: Duration(milliseconds: 400),
                      alignment: AlignmentDirectional.topStart,
                      textAlign: TextAlign.start,
                      textStyle: TextStyle(
                        color: Colors.green,
                        fontSize: 27,
                        fontFamily: 'RobotMono',
                      ),
                    ),
                    TyperAnimatedTextKit(
                      text: [
                        "Vânzare",
                      ],
                      pause: Duration(milliseconds: 1800),
                      speed: Duration(milliseconds: 400),
                      alignment: AlignmentDirectional.topEnd,
                      textAlign: TextAlign.start,
                      textStyle: TextStyle(
                        color: Colors.green,
                        fontSize: 27,
                        fontFamily: 'RobotMono',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<BankInfoBloc, BankInfoStates>(
                  cubit: _bankInfoBloc,
                  builder: (context, state) {
                    if (_bankInfoBloc.rates == null) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return this.cell(_bankInfoBloc.rates);
                    }
                  },
                )
              ],
            ),
          )),
    );
  }

  Widget cell(data) {
    return Expanded(
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                elevation: 0,
                color: Colors.transparent,
                child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            double.parse(data[index]
                                        .rate_sell
                                        .toStringAsFixed(1))
                                    .toString() +
                                " MDL",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontFamily: 'RobotMono',
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Container(
                                margin: EdgeInsets.only(top: 5),
                                child: ColorizeAnimatedTextKit(
                                    onTap: () {
                                      print(data[index].currency.toString());
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ReportsScreen(data[index].currency),
                                          ));
                                    },
                                    repeatForever: true,
                                    text: [
                                      data[index].currencyName,
                                    ],
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontFamily: "Horizon"),
                                    colors: [
                                      Colors.black,
                                      Colors.red,
                                      Colors.black
                                    ],
                                    textAlign: TextAlign.start,
                                    alignment: AlignmentDirectional
                                        .topStart // or Alignment.topLeft
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          child: Text(
                            double.parse(
                                        data[index].rate_buy.toStringAsFixed(1))
                                    .toString() +
                                " MDL",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontFamily: 'RobotMono',
                            ),
                          ),
                        ),
                      ],
                    )));
          }),
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

abstract class OnError {
  void onError(var errorText);
}
