import 'package:e_wallet/MainScreen/MainScreenComponents/Network_Indicator/network_indicator.dart';
import 'package:e_wallet/rest/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> with ResetPasswordScreenEvents{
  String email;
  var response;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Center(
            child: Column(
          children: [
            SizedBox(height: 10),
            Text("Wallet Page",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20))
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
          NetworkIndicator(),
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
          SizedBox(height: 30),
          RaisedButton(
            child: Text("Reset Password"),
            onPressed: () async {
              await AuthRepository().resetPassword(email, (error) {
                print(error.toString());
                this.onError(error);
              });

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
          )
        ],
      ),
    );
  }

  @override
  void onError(errorText) {
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

abstract class ResetPasswordScreenEvents {
  void onError(var errorText);
}