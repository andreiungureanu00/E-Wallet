import 'dart:convert';

import 'package:e_wallet/AuthScreen/sign_up_page_screen.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/MainScreen/main_screen.dart';
import 'package:e_wallet/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String email, password, name, photoUrl;
  var jwt;
  var profile;
  var graphResponse;
  FirebaseUser _user;
  bool isSignInGoogle = false;
  bool isSignInFacebook = false;
  bool login = false;
  GoogleSignIn _googleSignIn = new GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);
  User currentUser;

  bool isSignIn = false;
  var facebookLogin = new FacebookLogin();

  @override
  void initState() {
    super.initState();
  }

  getCredentials() async {}

  void _logInWithFacebook() async {
    var result = await facebookLogin.logIn(['email']);

    if (result.status == FacebookLoginStatus.loggedIn) {
      try {
        var facebookLoginResult = await facebookLogin.logIn(['email']);
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(400)&access_token=${facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);

        setState(() {
          isSignInFacebook = true;
          isSignInGoogle = false;
          isSignIn = false;
        });

        currentUser = User(
            profile["first_name"],
            profile["last_name"],
            profile["email"],
            profile["name"],
            profile["password"],
            profile["picture"]["data"]["url"]);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(currentUser),
            ));
      } on PlatformException catch (e) {
        print(e.toString());
      }
    } else if (result.status == FacebookLoginStatus.cancelledByUser) {
      print("CancelledByUser");
    } else if (result.status == FacebookLoginStatus.error) {
      print("Error");
    }
  }

  void _logoutFromFacebook() async {
    facebookLogin.logOut();
    setState(() {
      isSignInFacebook = false;
    });
  }

  void _logInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    AuthResult result = (await _auth.signInWithCredential(credential));
    _user = result.user;

    currentUser = User(_user.displayName, _user.displayName, _user.email, _user.email, "", _user.photoUrl);

    setState(() {
      isSignInGoogle = true;
      isSignInFacebook = false;
      isSignIn = false;
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MainScreen(currentUser),
          ));
    });
  }

  Future<void> googleSignout() async {
    await _auth.signOut().then((onValue) {
      _googleSignIn.signOut();
      setState(() {
        isSignInGoogle = false;
      });
    });
  }

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
                        email = value; // get value from TextField
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
                        password = value; //get value from textField
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
                                        email: email, password: password);

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

//                                  currentUser = User()

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainScreen(
                                            currentUser),
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
                            isSignIn ? "Login" : "Logout",
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
                                  onPressed: _logoutFromFacebook,
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
                                    _logInWithFacebook();
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
                                      googleSignout();
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
                                _logInWithGoogle();
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
