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

class _BankPageState extends State<BankPage> with OnError {
  List<Bank> banks;
  List<Coin> coins;
  String url = "http://60106d01af44.ngrok.io";
  BankPageBloc _bankPageBloc;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _bankPageBloc = BankPageBloc(this);
    _bankPageBloc.loadBanks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
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
                            return Container(
                                child: Column(
                              children: <Widget>[
                                Card(
                                  elevation: 5,
                                  color: Colors.transparent,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height-80,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                margin:
                                                EdgeInsets.only(top: 10),
                                                child: Text(
                                                  _bankPageBloc.banks[index]
                                                      .registered_name,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 34,
                                                    fontFamily: 'RobotMono',
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                  child: Image(
                                                      image: AssetImage("assets/${_bankPageBloc.banks[index]
                                                          .registered_name}.png"),
                                                      width: MediaQuery.of(context).size.width/1.5,
                                                      height: MediaQuery.of(context).size.height/1.5)
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
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
                                                                        .banks[
                                                                    index]),
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
                                                      Colors.black,
                                                      Colors.blue,
                                                    ],
                                                    textAlign: TextAlign.start,
                                                    alignment: AlignmentDirectional
                                                        .topStart // or Alignment.topLeft
                                                ),
                                                onTap: () {
                                                  print(_bankPageBloc
                                                      .banks[index].id
                                                      .toString());
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              BankInfoPage(
                                                                  _bankPageBloc
                                                                      .banks[
                                                                  index])));
                                                },
                                              ),
                                            ],
                                          ),

                                        ],
                                      )),
                                ),
                              ],
                            ));
                          }))
                ],
              );
            } else {
              return Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 3),
                  Container(child: CircularProgressIndicator())
                ],
              );
            }
          }),
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
}

abstract class OnError {
  void onError(var errorText);
}
