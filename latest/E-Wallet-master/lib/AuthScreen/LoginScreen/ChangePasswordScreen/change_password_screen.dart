import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/rest/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChangePassword extends StatefulWidget {
  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  String email;
  String oldPassword;
  String newPassword;
  String accessToken;
  var response;
  bool nextStep = false;

  @override
  void initState() {
    accessToken = CurrentUserSingleton().getAccessToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Column(
              children: [
                SizedBox(height: 10),
              ],
            )),
        elevation: 0,
        backgroundColor: Colors.grey[600],
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
      body: Column(
        children: [
          SizedBox(height: 50),
          nextStep == false ? Container(
            child: Column(
              children: [
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ),
                SizedBox(height: 10),
              ],
            ),
          ) : Container(),
          nextStep == true ? Container(
            child: Column(
              children: [
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    oldPassword = value;
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your user ID",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ),
                SizedBox(height: 10),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    oldPassword = value;
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your accessToken",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ),
                SizedBox(height: 10),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    oldPassword = value;
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your old password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ),
                SizedBox(height: 10),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    newPassword = value;
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your new password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ),
              ],
            ),
          ) : Container(),
          SizedBox(height: 30),
          nextStep == false ? RaisedButton(
            child: Text("Next"),
            onPressed: () async {
              setState(() {
                nextStep = true;
              });
              await AuthRepository().resetPassword(email);

              Fluttertoast.showToast(
                  msg:
                  "Check your email. A link with password change has been sent",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.blueAccent,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ) : RaisedButton(
            child: Text("Reset Password"),
            onPressed: () async {
              await AuthRepository().changePassword(oldPassword, newPassword, accessToken, 22);

              Fluttertoast.showToast(
                  msg:
                  "Check your email. A link with password change has been sent",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.blueAccent,
                  textColor: Colors.white,
                  fontSize: 16.0);

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
