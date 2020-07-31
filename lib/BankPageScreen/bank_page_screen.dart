import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:e_wallet/BankPageScreen/bloc/bank_page_bloc.dart';
import 'package:e_wallet/BankPageScreen/bloc/bank_page_states.dart';
import 'package:e_wallet/models/bank.dart';
import 'package:e_wallet/models/coin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../BankInfoScreen/bank_info_screen.dart';

class BankPage extends StatefulWidget {
  @override
  _BankPageState createState() => _BankPageState();
}

class _BankPageState extends State<BankPage> {
  List<Bank> banks;
  List<Coin> coins;
  String url = "http://60106d01af44.ngrok.io";
  BankPageBloc _bankPageBloc;

  @override
  void initState() {
    super.initState();
    _bankPageBloc = BankPageBloc();
    _bankPageBloc.loadBanks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE1E9E5),
      appBar: AppBar(
        title: Center(
            child: Column(
          children: [
            SizedBox(height: 10),
            Text("Banks",
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
      body: BlocBuilder<BankPageBloc, BankPageStates>(
          bloc: _bankPageBloc,
          builder: (context, state) {
            if (_bankPageBloc.banks != null) {
              return Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: _bankPageBloc.banks.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (_bankPageBloc.banks != null) {
                        return Container(
                            child: Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Card(
                              color: Colors.transparent,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffE1E9E5),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue,
                                        Colors.red,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              _bankPageBloc
                                                  .banks[index].registered_name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontFamily: 'RobotMono',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              _bankPageBloc
                                                  .banks[index].short_name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'RobotMono',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              _bankPageBloc
                                                  .banks[index].website,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'RobotMono',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        child: ColorizeAnimatedTextKit(
                                            onTap: () {
//                                                      BanksDatabase().newBank(_bankPageBloc.banks[index]);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BankInfoPage(
                                                            _bankPageBloc
                                                                .banks[index]),
                                                  ));
                                            },
                                            repeatForever: true,
                                            text: [
                                              "Cursul Valutar",
                                            ],
                                            textStyle: TextStyle(
                                                fontSize: 25,
                                                fontFamily: "Horizon"),
                                            colors: [
                                              Colors.white,
                                              Colors.black,
                                              Colors.black,
                                              Colors.white,
                                            ],
                                            textAlign: TextAlign.start,
                                            alignment: AlignmentDirectional
                                                .topStart // or Alignment.topLeft
                                            ),
                                        onTap: () {
                                          print(_bankPageBloc.banks[index].id
                                              .toString());
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BankInfoPage(_bankPageBloc
                                                          .banks[index])));
                                        },
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ))
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
