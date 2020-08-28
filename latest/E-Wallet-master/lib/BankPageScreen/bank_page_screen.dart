import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:e_wallet/BankPageScreen/bloc/bank_page_bloc.dart';
import 'package:e_wallet/BankPageScreen/bloc/bank_page_states.dart';
import 'package:e_wallet/MainScreen/MainScreenComponents/Network_Indicator/network_indicator.dart';
import 'package:e_wallet/models/bank.dart';
import 'package:e_wallet/models/coin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  BankPageBloc _bankPageBloc;
  ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    _bankPageBloc = BankPageBloc(this);
    _bankPageBloc.loadBanks();
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
        scrollController.offset + MediaQuery
            .of(context)
            .size
            .width + 10,
        curve: Curves.linear,
        duration: Duration(milliseconds: 400));
  }

  _moveDown() {
    scrollController.animateTo(
        scrollController.offset - MediaQuery
            .of(context)
            .size
            .width-10,
        curve: Curves.linear,
        duration: Duration(milliseconds: 400));
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
                        fontSize: 30))
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
        backgroundColor: Colors.white,
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
          cubit: _bankPageBloc,
          builder: (context, state) {
            if (_bankPageBloc.banks != null) {
              return Column(
                children: [
                  NetworkIndicator(),
                  Expanded(
                      child: ListView.builder(
                          controller: scrollController,
                          itemCount: _bankPageBloc.banks.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      child: Card(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: Container(
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            height:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .height -
                                                140,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(7),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      margin:
                                                      EdgeInsets.only(top: 10),
                                                      child: Text(
                                                        _bankPageBloc
                                                            .banks[index]
                                                            .registered_name,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 34,
                                                          fontFamily: 'RobotMono',
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Container(
                                                            child: Image(
                                                                image: AssetImage(
                                                                    "assets/${_bankPageBloc
                                                                        .banks[index]
                                                                        .registered_name}.png"),
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width -
                                                                    20,
                                                                height: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .height /
                                                                    1.7)),
                                                      ],
                                                    ),
                                                    InkWell(
                                                      child:
                                                      ColorizeAnimatedTextKit(
                                                          onTap: () {
//                                                      BanksDatabase().newBank(_bankPageBloc.banks[index]);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (
                                                                      context) =>
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
                                                              fontFamily:
                                                              "Horizon"),
                                                          colors: [
                                                            Colors.black,
                                                            Colors.blue,
                                                          ],
                                                          textAlign:
                                                          TextAlign.start,
                                                          alignment:
                                                          AlignmentDirectional
                                                              .topStart // or Alignment.topLeft
                                                      ),
                                                      onTap: () {
                                                        print(_bankPageBloc
                                                            .banks[index].id
                                                            .toString());
                                                        Navigator.of(context)
                                                            .push(
                                                            MaterialPageRoute(
                                                                builder: (
                                                                    context) =>
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
                                      onTap: _moveUp,
                                      onDoubleTap: _moveDown,
                                    ),
                                  ],
                                ));
                          }))
                ],
              );
            } else {
              return Column(
                children: [
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height / 3),
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
