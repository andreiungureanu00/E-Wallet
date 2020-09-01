import 'package:e_wallet/AuthScreen/LoginScreen/ChangePasswordScreen/bloc/change_password_events.dart';
import 'package:e_wallet/AuthScreen/LoginScreen/ChangePasswordScreen/bloc/change_password_states.dart';
import 'package:e_wallet/CurrentUserSingleton/current_user_singleton.dart';
import 'package:e_wallet/rest/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordPageBloc extends Bloc<ChangePasswordEvents, ChangePasswordStates> {

  bool nextStep = false;
  String email;
  String oldPassword;
  String newPassword;
  var accessToken;

  ChangePasswordPageBloc() : super(ChangePasswordPageInit());

  @override
  Stream<ChangePasswordStates> mapEventToState(ChangePasswordEvents event) async*{
    if (event is LoadSecondStep) {
      nextStep = true;
      yield ChangePasswordPageLoaded();
    }

    if (event is ResetPassword) {
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
      yield ChangePasswordPageLoaded();
    }

    if (event is ChangePassword) {
      accessToken = CurrentUserSingleton().getAccessToken();
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
    }
    yield ChangePasswordPageLoaded();
  }

  resetPassword() {
    add(ResetPassword());
  }

  changePassword() {
    add(ChangePassword());
  }

  loadNextStep() {
    add(LoadSecondStep());
  }

}
