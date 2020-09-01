import 'package:e_wallet/AuthScreen/LoginScreen/ChangePasswordScreen/bloc/change_password_bloc.dart';
import 'package:e_wallet/AuthScreen/LoginScreen/ChangePasswordScreen/bloc/change_password_states.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/rest/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget {
  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  ChangePasswordPageBloc _pageBloc;

  @override
  void initState() {
    _pageBloc = ChangePasswordPageBloc();
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
          BlocBuilder<ChangePasswordPageBloc, ChangePasswordStates>(
              cubit: _pageBloc,
              builder: (context, state) {
                if (_pageBloc.nextStep == false) {
                  print("nextstep este emm " + _pageBloc.nextStep.toString());
                  return Container(
                    child: Column(
                      children: [
                        TextField(
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            _pageBloc.email = value;
                          },
                          decoration: InputDecoration(
                              hintText: "Enter your email",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)))),
                        ),
                        SizedBox(height: 30),
                        RaisedButton(
                          child: Text("Next"),
                          onPressed: () async {
                            _pageBloc.loadNextStep();
                            _pageBloc.resetPassword();
                          },
                        )
                      ],
                    ),
                  );
                } else {
                  return Container(
                    child: Column(
                      children: [
                        TextField(
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            _pageBloc.oldPassword = value;
                          },
                          decoration: InputDecoration(
                              hintText: "Enter your old password",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)))),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            _pageBloc.newPassword = value;
                          },
                          decoration: InputDecoration(
                              hintText: "Enter your new password",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)))),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(
                          child: Text("Reset Password"),
                          onPressed: () async {
                            _pageBloc.changePassword();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
