import 'package:e_wallet/MainScreen/MainScreenComponents/Network_Indicator/bloc/network_indicator_events.dart';
import 'package:e_wallet/MainScreen/MainScreenComponents/Network_Indicator/bloc/network_indicator_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkIndicatorBloc
    extends Bloc<NetworkIndicatorEvents, NetworkIndicatorStates> {
  NetworkIndicatorBloc() : super(Hidden());

  bool visibility = false;
  bool connected;

  checkConnection(bool connected) {
    if (connected == true) {
      Future.delayed(const Duration(seconds: 2)).then((value) {
        hideIndicator();
        reloadIndicator();
      });
    } else if (connected == false) {
      showIndicator();
      reloadIndicator();
    }
  }

  @override
  Stream<NetworkIndicatorStates> mapEventToState(
      NetworkIndicatorEvents event) async* {
    if (event is ShowNetworkIndicator) {
      visibility = true;
      yield Shown();
    }
    if (event is HideNetworkIndicator) {
      visibility = false;
      yield Hidden();
    }
  }

  showIndicator() {
    add(ShowNetworkIndicator());
  }

  hideIndicator() {
    add(HideNetworkIndicator());
  }

  reloadIndicator() {
    add(ReloadIndicator());
  }
}
