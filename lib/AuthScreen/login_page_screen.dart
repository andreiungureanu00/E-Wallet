import 'package:e_wallet/AuthScreen/sign_up_page_screen.dart';
import 'package:e_wallet/MainScreen/main_screen.dart';
import 'package:e_wallet/models/user.dart';
import 'package:e_wallet/rest/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  User currentUser;
  bool showProgress;
  bool isSignIn = false, isSignInFacebook = false, isSignInGoogle = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE1E9E5),
        appBar: AppBar(
          title: Center(
              child: Column(
            children: [
              SizedBox(height: 5),
              Text("Login Page",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ],
          )),
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
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 120.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        currentUser.email = value; // get value from TextField
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your Email",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)))),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        currentUser.password = value; //get value from textField
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your Password",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)))),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text(
                        "Are you new here? Sign Up",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(height: 15),
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
                              if (isSignIn == false) {
                                final newUser =
                                    await _auth.signInWithEmailAndPassword(
                                        email: currentUser.email,
                                        password: currentUser.password);

                                if (newUser != null) {
                                  Fluttertoast.showToast(
                                      msg: "Login Successfull",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.blueAccent,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  setState(() {
                                    showProgress = false;
                                  });

                                  var photoUrl =
                                      "https://scontent.fkiv4-1.fna.fbcdn.net/v/t1.30497-1/s480x480/84628273_176159830277856_972693363922829312_n.jpg?_nc_cat=1&_nc_sid=12b3be&_nc_ohc=EiCVFZsOtR0AX8bAVby&_nc_ht=scontent.fkiv4-1.fna&_nc_tp=7&oh=4ca52c73ce307020f39f4731f487731d&oe=5F3BA3AA";

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MainScreen(currentUser),
                                      ));
                                }
                              } else {
                                await _auth.signOut();
                              }
                            } catch (e) {}
                          },
                          minWidth: 200.0,
                          height: 25.0,
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20.0),
                          ),
                        )),
                    isSignInFacebook
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 50),
                                RaisedButton(
                                  child: Text(
                                    "Logout from Facebook",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    AuthRepository().logoutFromFacebook();
                                    setState(() {
                                      isSignInFacebook = false;
                                    });
                                  },
                                  color: Colors.indigo,
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                SizedBox(height: 60),
                                FacebookSignInButton(
                                  onPressed: () {
                                    AuthRepository()
                                        .logInWithFacebook(currentUser);
                                    setState(() {
                                      isSignInFacebook = true;
                                      isSignInGoogle = false;
                                      isSignIn = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MainScreen(currentUser),
                                        ));
                                  },
                                )
                              ]),
                    isSignInGoogle
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                  width: 220,
                                  child: FlatButton(
                                    color: Color(0xffE1E9E5),
                                    onPressed: () {
                                      AuthRepository().googleSignout();
                                      setState(() {
                                        isSignInGoogle = false;
                                      });
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
                                          child: Text("Logout from Google"),
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
                              color: Color(0xffE1E9E5),
                              onPressed: () {
                                AuthRepository().logInWithGoogle(currentUser);
                                setState(() {
                                  isSignInGoogle = true;
                                  isSignInFacebook = false;
                                  isSignIn = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MainScreen(currentUser),
                                    ));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn.windowsreport.com%2Fwp-content%2Fuploads%2F2016%2F10%2FGoogle-icon.jpg&f=1&nofb=1"),
                                  ),
                                  SizedBox(width: 10),
                                  Center(
                                    child: Text("Login with Google"),
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
        )));
  }
}
