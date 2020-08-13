import 'package:e_wallet/MainScreen/MainScreenComponents/Network_Indicator/bloc/network_indicator_bloc.dart';
import 'package:e_wallet/MainScreen/MainScreenComponents/Network_Indicator/bloc/network_indicator_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:connectivity/connectivity.dart';

class NetworkIndicator extends StatefulWidget {
  @override
  NetworkIndicatorState createState() => NetworkIndicatorState();
}

class NetworkIndicatorState extends State<NetworkIndicator> {
  NetworkIndicatorBloc _networkIndicatorBloc;

  @override
  void initState() {
    _networkIndicatorBloc = NetworkIndicatorBloc();
    _networkIndicatorBloc.hideIndicator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkIndicatorBloc, NetworkIndicatorStates>(
      cubit: _networkIndicatorBloc,
      builder: (context, state) {
        return SizedBox(
          child: Builder(
            // pageBody()
            builder: (BuildContext context) {
              return OfflineBuilder(
                  connectivityBuilder: (BuildContext context,
                      ConnectivityResult connectivity, Widget child) {
                    final bool connected =
                        connectivity != ConnectivityResult.none;

                    _networkIndicatorBloc.checkConnection(connected);

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        child,
                        Positioned(
                          left: 0.0,
                          right: 0.0,
                          height: 30.0,
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            color: connected
                                ? (_networkIndicatorBloc.visibility
                                    ? Colors.green
                                    : Colors.transparent)
                                : Color(0xFFEE4400),
                            child: connected
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Visibility(
                                        child: Text("Connected"),
                                        visible:
                                            _networkIndicatorBloc.visibility,
                                      )
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "OFFLINE",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      SizedBox(
                                        width: 12.0,
                                        height: 12.0,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                  child: Container());
            },
          ),
          height: 30,
        );
      },
    );
  }
}
