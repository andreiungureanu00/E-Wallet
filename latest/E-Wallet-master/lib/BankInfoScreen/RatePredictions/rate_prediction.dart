import 'package:dio/dio.dart';
import 'package:e_wallet/models/coin.dart';
import 'package:e_wallet/rest/StringConfigs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RatePredictionPage extends StatefulWidget {
  int coinID;

  RatePredictionPage(this.coinID);

  @override
  _RatePredictionPageState createState() => _RatePredictionPageState(coinID);
}

class _RatePredictionPageState extends State<RatePredictionPage> {
  int coinID;
  String dropdownValue;
  List<String> dates = [];
  bool visible = false;
  var rate_sell;

  _RatePredictionPageState(this.coinID);

  getDates(int coin) async {
    var response;
    Dio dio = new Dio();

    response = await dio.get(
        "${StringConfigs.baseApiUrl}/exchange/prediction/?currency=$coinID");

    for (var element in response.data) {
      String date = element["date"];
      if (!dates.contains(date)) dates.add(date);
    }

    if (dropdownValue == null) dropdownValue = dates[0];
  }

  Future<String> getRatePrediction(int coin, String date) async {
    var response;
    Dio dio = new Dio();
    var value_sell;

    response = await dio.get(
        "${StringConfigs.baseApiUrl}/exchange/prediction/?date=$date&currency=$coinID");

    print(response.toString());

    for (var element in response.data) {
      value_sell = element["rate_sell"];
    }


    return value_sell.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: getDates(coinID),
            builder: (context, snapshot) {
              if (dates != null) {
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
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) async {
                              setState(() {
                                dropdownValue = newValue;
                                visible = true;
                              });
                              rate_sell = await getRatePrediction(
                                  coinID, dropdownValue);
                            },
                            items: dates
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                    value,
                                  style: TextStyle(
                                    fontSize: 23
                                  ),
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
                              "In data de $dropdownValue cursul se asteapta sa fie $rate_sell",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,),
                        ),
                        visible: visible,
                      )
                    ],
                  ),
                );
              } else
                return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
