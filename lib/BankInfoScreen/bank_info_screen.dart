import 'package:e_wallet/BankInfoScreen/bloc/bank_info_bloc.dart';
import 'package:e_wallet/BankInfoScreen/bloc/bank_info_states.dart';
import 'package:e_wallet/ReportsScreen/reports_screen.dart';
import 'package:e_wallet/models/bank.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
      backgroundColor: Color(0xffE1E9E5),
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
                      fontSize: 25,
                      fontFamily: 'RobotMono',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<BankInfoBloc, BankInfoStates>(
                  bloc: _bankInfoBloc,
                  builder: (context, state) {
                    if (_bankInfoBloc.coins == null) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return this.cell(_bankInfoBloc.coins);
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
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xffE1E9E5), Colors.white]),
                        borderRadius: BorderRadius.circular(7)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              child: Container(
                                child: Text(
                                  data[index].name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontFamily: 'RobotMono',
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                data[index].abbr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontFamily: 'RobotMono',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: TypewriterAnimatedTextKit(
                                  text: [
                                    "Cursul curent",
                                  ],
                                  repeatForever: true,
                                  textStyle: TextStyle(
                                    color: Colors.green,
                                    fontSize: 19,
                                    fontFamily: 'RobotMono',
                                  ),
                                )),
                            Container(
                              child: Text(
                                "Vânzare: " +
                                    data[index].rate_sell.toString() +
                                    " MDL",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontFamily: 'RobotMono',
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Cumpărare: " +
                                    data[index].rate_buy.toString() +
                                    " MDL",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontFamily: 'RobotMono',
                                ),
                              ),
                            ),
                            FlatButton(
                                child: Text(
                                  "Reports",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReportsScreen(data[index].id),
                                      ));
                                }),
                            SizedBox(
                              height: 20,
                            )
                          ],
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
