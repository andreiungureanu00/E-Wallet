
import 'package:e_wallet/Notifications/notifications_list/bloc/notifications_list_bloc.dart';
import 'package:e_wallet/Notifications/notifications_list/bloc/notifications_list_states.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Notifications extends StatefulWidget {
  NotificationsState createState() => NotificationsState();
}

class NotificationsState extends State<Notifications> with NotificationsEvents {
  NotificationsListBloc _listBloc;

  @override
  void initState() {
    _listBloc = NotificationsListBloc(this);
    _listBloc.loadNotifications();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 70,),
                Text("Notifications",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  textAlign: TextAlign.center,),
              ],
            )
          ],
        ),
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
      body: BlocBuilder<NotificationsListBloc, NotificationsListStates>(
        cubit: _listBloc,
        builder: (context, state) {
          return ListView.builder(
            itemCount: _listBloc.notificationsList.length,
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        "Price Forecast",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          _listBloc.notificationsList[index].body,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      )
    );
  }

  @override
  void loadNotifications() {
    print("am scos tot");
  }
}

abstract class NotificationsEvents {
  void loadNotifications();
}
