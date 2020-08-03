import 'package:e_wallet/AuthScreen/SignUpScreen/signup_bloc/signup_page_events.dart';
import 'package:e_wallet/AuthScreen/SignUpScreen/signup_bloc/signup_page_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPageBloc extends Bloc<SignUpPageEvents, SignUpPageStates> {
  bool showProgress = false;
  String firstName, lastName, email, password, username;

  @override
  SignUpPageStates get initialState => SignUpPageInit();

  @override
  Stream<SignUpPageStates> mapEventToState(SignUpPageEvents event) async* {
    if (event is LoadSignUpPage) {
      yield SignUpPageLoaded();
    }

    if (event is ReloadSignUpPage) {
      yield SignUpPageLoaded();
    }
  }

  loadSignUpPage() {
    add(LoadSignUpPage());
  }

  reloadSignUpPage() {
    add(ReloadSignUpPage());
  }
}
