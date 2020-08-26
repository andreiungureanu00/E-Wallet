import 'package:e_wallet/AuthScreen/FingerPrintScreen/bloc/fingerprint_screen_events.dart';
import 'package:e_wallet/AuthScreen/FingerPrintScreen/bloc/fingerprint_screen_states.dart';
import 'package:e_wallet/BankPageScreen/bloc/bank_page_events.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/models/user.dart';
import 'package:e_wallet/MainScreen/main_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../finger_print_screen.dart';

class FingerPrintScreenBloc
    extends Bloc<FingerPrintScreenEvents, FingerPrintScreenStates> {
  final LocalAuthentication localAuth = LocalAuthentication();
  bool weCanCheckBiometrics = false, authenticated = false;
  CurrentUser user;
  FingerPrintEvent _event;

  FingerPrintScreenBloc(this._event) : super(FingerPrintScreenInit());

  @override
  Stream<FingerPrintScreenStates> mapEventToState(
      FingerPrintScreenEvents event) async* {
    if (event is GetUser) {
      await CurrentUserSingleton().getCurrentUserAsync();
      user = CurrentUserSingleton().getCurrentUser();
      yield FingerPrintScreenLoaded();
    }

    if (event is TakeFingerPrint) {
      weCanCheckBiometrics = await localAuth.canCheckBiometrics;

      if (weCanCheckBiometrics) {
        authenticated = await localAuth.authenticateWithBiometrics(
            localizedReason: "FingerPrint");
        _event.onFingerPrintTaken();
      }
      yield FingerPrintScreenLoaded();
    }
  }

  takeFingerPrint() {
    add(TakeFingerPrint());
  }

  getUser() {
    add(GetUser());
  }
}
