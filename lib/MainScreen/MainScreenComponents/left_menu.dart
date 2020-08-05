import 'package:e_wallet/BankPageScreen/bank_page_screen.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_bloc.dart';
import 'package:e_wallet/MainScreen/bloc/main_screen_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main_screen.dart';

// ignore: must_be_immutable
class LeftMenu extends StatefulWidget {
  var data;

  LeftMenu(this.data);

  @override
  _LeftMenuState createState() => _LeftMenuState(data);
}

// snack bar windows for exceptions

class _LeftMenuState extends State<LeftMenu> {
  var data;

  _LeftMenuState(this.data);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.white70, Colors.red])),
          child: UserAccountsDrawerHeader(
            accountEmail: Text(data.currentUser.email),
            accountName: Text(data.currentUser.username),
            currentAccountPicture: CircleAvatar(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  fit: BoxFit.fill,
                  image: NetworkImage(data.currentUser.photoUrl),
                ),
              ),
            ),
          ),
        ),
        ListTile(
          title: Text("Wallets"),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => MainScreen()));
          },
        ),
        ListTile(
          title: Text("Banks"),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => BankPage()));
          },
        ),
        ListTile(
          title: Text("Help"),
          onTap: () {},
        ),
      ],
    );
  }
}
