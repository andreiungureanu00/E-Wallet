import 'package:e_wallet/CurrentUserSingleton/shared_preferences.dart';
import 'package:e_wallet/models/user.dart';

class CurrentUserSingleton {
  static final CurrentUserSingleton _singleton =
      new CurrentUserSingleton._internal();

  factory CurrentUserSingleton() {
    return _singleton;
  }

  CurrentUserSingleton._internal();

  String _currentAccessToken;
  CurrentUser _currentUser;

  getAccessTokenAsync() async {
    _currentAccessToken = await SharedPreference().getAccessToken();
  }

  setAccessTokenAsync(String accessToken) async {
    _currentAccessToken = accessToken;
    await SharedPreference().setAccessToken(accessToken);
  }

  String getAccessToken() {
    return _currentAccessToken;
  }

  getCurrentUserAsync() async {
    _currentUser = await SharedPreference().getCurrentUser();
  }

  setCurrentUserAsync(CurrentUser user) async {
    _currentUser = user;
    await SharedPreference().setCurrentUser(user);
  }

  CurrentUser getCurrentUser() {
    return _currentUser;
  }

  logout() async {
    setAccessTokenAsync(null);
//    setCurrentUserAsync(null);
    await SharedPreference().logOutUser();
  }
}
