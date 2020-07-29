import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WalletCreate extends StatefulWidget {
  @override
  WalletCreateState createState() => WalletCreateState();
}

class WalletCreateState extends State<WalletCreate> {
  String currencyName;
  int currencyID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
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
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  currencyName = value; //get value from textField
                },
                decoration: InputDecoration(
                    hintText: "Enter Wallet Currency Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  currencyID = int.parse(value);
                  print(currencyID); //get value from textField
                },
                decoration: InputDecoration(
                    hintText: "Enter Wallet Currency ID",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
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
                  WalletsRepository().createWallet(currencyID);
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
