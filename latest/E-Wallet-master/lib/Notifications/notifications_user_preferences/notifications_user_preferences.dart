import 'package:e_wallet/Notifications/notifications_user_preferences/bloc/user_notifications_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_notifications_states.dart';

class NotificationsUserPreferences extends StatefulWidget {
  @override
  NotificationsUserPreferencesStates createState() =>
      NotificationsUserPreferencesStates();
}

class NotificationsUserPreferencesStates
    extends State<NotificationsUserPreferences> {
  UserNotificationsBloc _notificationsBloc;

  @override
  void initState() {
    _notificationsBloc = UserNotificationsBloc();
    _notificationsBloc.initList();
    _notificationsBloc.initPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserNotificationsBloc, UserNotificationsStates>(
        cubit: _notificationsBloc,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            child: Text(
                                "Choose percentage\nfor Percentage\nDown Limit",
                                style: TextStyle(fontSize: 16)),
                          ),
                          SizedBox(height: 20),
                          DropdownButton<String>(
                            value: _notificationsBloc.defaultPercentage,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) {
                              _notificationsBloc.defaultPercentage = newValue;
                              _notificationsBloc.reloadPage();
                              _notificationsBloc.setPercentageDown();
                            },
                            items: _notificationsBloc.percentsList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 23),
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            child: Text(
                                "Choose percentage\nfor Percentage\nDown Forecast\n Limit",
                                style: TextStyle(fontSize: 16)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          DropdownButton<String>(
                            value: _notificationsBloc.defaultForecastPercentage,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) {
                              _notificationsBloc.defaultForecastPercentage = newValue;
                              _notificationsBloc.reloadPage();
                              _notificationsBloc.setPercentageForecastDown();
                            },
                            items: _notificationsBloc.percentsForecastList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 23),
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

abstract class NotificationsUserPreferencesEvents {
  void onPercentageDownSet();

  void onPercentageForecastDownSet();
}
