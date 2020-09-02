import 'package:e_wallet/AuthScreen/SignUpScreen/sign_up_page_screen.dart';
import 'package:e_wallet/AuthScreen/SignUpScreen/signup_bloc/signup_page_events.dart';
import 'package:e_wallet/AuthScreen/SignUpScreen/signup_bloc/signup_page_states.dart';
import 'package:e_wallet/rest/register_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPageBloc extends Bloc<SignUpPageEvents, SignUpPageStates> {
  bool showProgress = false;
  String firstName, lastName, email, password, username;
  SignUpScreenEvents _event;

  SignUpPageBloc(this._event) : super(SignUpPageInit());

  @override
  Stream<SignUpPageStates> mapEventToState(SignUpPageEvents event) async* {
    if (event is LoadSignUpPage) {
      yield SignUpPageLoaded();
    }

    if (event is ReloadSignUpPage) {
      yield SignUpPageLoaded();
    }

    if (event is SignUp) {
      await RegisterRepository().createUser(
          firstName,
          lastName,
          email,
          password,
          username, (error) {
        print(error.toString());
        _event.onError(error);
      });
      yield SignUpPageLoaded();
    }
  }

  loadSignUpPage() {
    add(LoadSignUpPage());
  }

  reloadSignUpPage() {
    add(ReloadSignUpPage());
  }

  signUp() {
    add(SignUp());
  }
}
