import 'package:dio/dio.dart';
import 'package:e_wallet/rest/StringConfigs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterRepository {
  static final RegisterRepository _singleton =
      new RegisterRepository._internal();

  factory RegisterRepository() {
    return _singleton;
  }

  RegisterRepository._internal();

  Future<void> createUser(String firstName, String lastName, String email,
      String password, String username, Function onError) async {
    Dio dio = new Dio();

    Map<String, dynamic> body = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "username": username,
      "password": password
    };

    String urlRegister = "${StringConfigs.baseApiUrl}/users/register/";
    try {
      var response;
      response = await dio.post(urlRegister, data: body);

      print(response.data.toString());
    }
    catch(exception) {
      if (exception is DioError)
        onError(exception.error);
    }
  }

  Future<void> createUserOnFirebase(String email, String password) async {
    final _auth = FirebaseAuth.instance;
    final newuser = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (newuser != null) {
      var profileUrl =
          "https://scontent.fkiv4-1.fna.fbcdn.net/v/t1.30497-1/s480x480/84628273_176159830277856_972693363922829312_n.jpg?_nc_cat=1&_nc_sid=12b3be&_nc_ohc=EiCVFZsOtR0AX8bAVby&_nc_ht=scontent.fkiv4-1.fna&_nc_tp=7&oh=4ca52c73ce307020f39f4731f487731d&oe=5F3BA3AA";
    }
  }
}
