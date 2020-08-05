import 'package:e_wallet/AuthScreen/SignUpScreen/sign_up_page_screen.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/MainScreen/main_screen.dart';
import 'package:e_wallet/rest/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_bloc/login_page_bloc.dart';
import 'login_bloc/login_page_states.dart';

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  var currentUser;
  String email, password, username;
  bool showProgress, isSetUser;
  final _auth = FirebaseAuth.instance;
  var accessToken;
  int authCode;
  LoginPageBloc _loginPageBloc;

  _MyLoginPageState();

  @override
  void initState() {
    _loginPageBloc = LoginPageBloc();
    _loginPageBloc.loadLoginPage();
    CurrentUserSingleton().getCurrentUserAsync().then((value) => null);
    currentUser = CurrentUserSingleton().getCurrentUser();
    if (currentUser != null) {
      authCode = currentUser.authCode;
    } else {
      authCode = -1;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE1E9E5),
        body: BlocBuilder<LoginPageBloc, LoginPageStates>(
            bloc: _loginPageBloc,
            builder: (context, state) {
              return SingleChildScrollView(
                  child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                      image: NetworkImage(
                          "https://www.elegantthemes.com/blog/wp-content/uploads/2013/09/bg-2-full.jpg")),
                ),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 240.0,
                          ),
                          TextField(
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              username = value; // get value from TextField
                            },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                                ),
                                hintText: 'Enter your Email',
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextField(
                            obscureText: true,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              password = value; //get value from textField
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white, width: 5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                                borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                              ),
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()),
                              );
                            },
                            child: Text(
                              "Are you new here? Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15),
                            ),
                          ),
                          SizedBox(height: 15),
                          Material(
                              elevation: 5,
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(32.0),
                              child: MaterialButton(
                                onPressed: () async {
                                  if (authCode != 3) {
                                    if (username != null && password != null) {
                                      AuthRepository().loginWithCredentials(
                                          username, password);

                                      showProgress = true;
                                      _loginPageBloc.reloadLoginPage();

                                      Fluttertoast.showToast(
                                          msg: "Login Successfull",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.blueAccent,
                                          textColor: Colors.white,
                                          fontSize: 16.0);

                                      showProgress = false;
                                      _loginPageBloc.reloadLoginPage();

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MainScreen(),
                                          ));
                                    }
                                  } else {
                                    _auth.signOut();
                                    _loginPageBloc.reloadLoginPage();
                                    await CurrentUserSingleton().logout();
                                    _loginPageBloc.reloadLoginPage();
                                  }
                                },
                                minWidth: 200.0,
                                height: 25.0,
                                child: Text(
                                  authCode == 3 ? "Logout" : "Login",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.0),
                                ),
                              )),
                          authCode == 1
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 50),
                                      FlatButton(
                                        child: Text(
                                          "Logout from Facebook",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          AuthRepository().logoutFromFacebook();
                                          authCode = 0;
                                          _loginPageBloc.reloadLoginPage();
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      SizedBox(height: 60),
                                      FacebookSignInButton(
                                        onPressed: () async {
                                          currentUser = await AuthRepository()
                                              .logInWithFacebook();

                                          _loginPageBloc.reloadLoginPage();

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MainScreen(),
                                              ));
                                        },
                                      )
                                    ]),
                          authCode == 2
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 220,
                                        child: FlatButton(
                                          onPressed: () {
                                            AuthRepository().googleSignout();
                                            authCode = 0;
                                            _loginPageBloc.reloadLoginPage();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn.windowsreport.com%2Fwp-content%2Fuploads%2F2016%2F10%2FGoogle-icon.jpg&f=1&nofb=1"),
                                              ),
                                              SizedBox(width: 10),
                                              Center(
                                                child:
                                                    Text(
                                                        authCode==2 ? "Logout from Google" : "Login with Google",
                                                      style: TextStyle(
                                                        color: Colors.white
                                                      ),
                                                    ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Center(
                                  child: FlatButton(
                                    onPressed: () async {
                                      currentUser = await AuthRepository()
                                          .logInWithGoogle();
                                      authCode = 2;

                                      _loginPageBloc.reloadLoginPage();

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MainScreen(),
                                          ));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn.windowsreport.com%2Fwp-content%2Fuploads%2F2016%2F10%2FGoogle-icon.jpg&f=1&nofb=1"),
                                        ),
                                        SizedBox(width: 10),
                                        Center(
                                          child: Text(
                                              "Login with Google",
                                            style: TextStyle(
                                              color: Colors.white
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
            }));
  }
}
