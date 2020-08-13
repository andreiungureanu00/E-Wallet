
abstract class LoginPageEvents extends Object {
  const LoginPageEvents();
}

class LoadLoginPage extends LoginPageEvents {}
class ReloadLoginPage extends LoginPageEvents {}
class LoginWithCredentials extends LoginPageEvents {}
class LoginWithFacebook extends LoginPageEvents {}
class LoginWithGoogle extends LoginPageEvents {}
class LogoutWithCredentials extends LoginPageEvents {}
class LogoutFromFacebook extends LoginPageEvents {}
class LogoutFromGoogle extends LoginPageEvents {}
