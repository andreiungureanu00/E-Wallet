import 'package:dio/dio.dart';
import 'package:e_wallet/rest/StringConfigs.dart';

class AuthRepository {
  String url = "http://live.curs-valutar.xyz";

  static final AuthRepository _singleton = new AuthRepository._internal();

  factory AuthRepository() {
    return _singleton;
  }

  AuthRepository._internal();

  Future<String> login(String username, String password) async {
    Dio dio = new Dio();

    Map<String, dynamic> body = {"username": username, "password": password};

    String urlToken = "${StringConfigs.baseApiUrl}/users/token-obtain/";

    var response = await dio.post(urlToken, data: body);

    return response.data["access"].toString();
  }
}
