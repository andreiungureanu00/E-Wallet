import 'package:e_wallet/BankInfoScreen/RatePredictions/bloc/rate_prediction_bloc.dart';
import 'package:e_wallet/BankInfoScreen/RatePredictions/bloc/rate_prediction_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatePredictionPage extends StatefulWidget {
  int coinID;

  RatePredictionPage(this.coinID);

  @override
  _RatePredictionPageState createState() => _RatePredictionPageState(coinID);
}

class _RatePredictionPageState extends State<RatePredictionPage> {
  int coinID;
  RatePredictionBloc _ratePredictionBloc;

  _RatePredictionPageState(this.coinID);

  @override
  void initState() {
    _ratePredictionBloc = RatePredictionBloc(coinID);
    _ratePredictionBloc.getDates(coinID).then((value) {
      print(_ratePredictionBloc.dates.length.toString());
      _ratePredictionBloc.reloadPage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<RatePredictionBloc, RatePredictionStates>(
              cubit: _ratePredictionBloc,
              builder: (context, snapshot) {
                return Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                            value: _ratePredictionBloc.dropdownValue,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) async {
                              _ratePredictionBloc.dropdownValue = newValue;
                              _ratePredictionBloc.visible = true;
                              _ratePredictionBloc.reloadPage();
                              _ratePredictionBloc.getRatePrediction();
                            },
                            items: _ratePredictionBloc.dates
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 23),
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Visibility(
                        child: Container(
                          child: Text(
                            _ratePredictionBloc.rate_sell != null ?
                            "In data de ${_ratePredictionBloc.dropdownValue} cursul se asteapta sa fie ${_ratePredictionBloc.rate_sell}" :
                            "",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        visible: _ratePredictionBloc.visible,
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
