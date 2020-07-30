import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_wallet/AuthScreen/login_page_screen.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/MainScreen/main_screen.dart';
import 'package:e_wallet/rest/register_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  bool showProgress = false;
  String firstName, lastName, email, password, username;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE1E9E5),
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(width: 100),
              Text("Sign Up",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ],
          ),
          elevation: 0,
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
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Registration Page",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
                ),
                SizedBox(
                  height: 40.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    firstName = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your First Name",
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    lastName = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Last Name",
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Email",
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Password",
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    username = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Choose an username",
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 60.0,
                ),
                Material(
                  elevation: 5,
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(32.0),
                  child: MaterialButton(
                    onPressed: () async {
                      setState(() {
                        showProgress = true;
                      });
                      try {
                        await RegisterRepository().createUser(
                            firstName, lastName, email, password, username);

                      } catch (e) {}
                    },
                    minWidth: 200.0,
                    height: 5.0,
                    child: Text(
                      "Register",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ));
  }
}
