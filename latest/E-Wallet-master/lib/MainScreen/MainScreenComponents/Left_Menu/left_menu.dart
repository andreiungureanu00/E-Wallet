import 'package:e_wallet/BankPageScreen/bank_page_screen.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main_screen.dart';


class LeftMenu extends StatefulWidget {
  var data;

  LeftMenu(this.data);

  @override
  _LeftMenuState createState() => _LeftMenuState(data);
}

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
            decoration: BoxDecoration(
              color: Colors.blueGrey
            ),
            accountEmail: Text(CurrentUserSingleton().getCurrentUser().email),
            accountName: Text(CurrentUserSingleton().getCurrentUser().username),
            currentAccountPicture: CircleAvatar(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  fit: BoxFit.fill,
                  image: NetworkImage(CurrentUserSingleton().getCurrentUser().photoUrl),
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
