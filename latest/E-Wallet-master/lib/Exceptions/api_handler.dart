
import 'app_exceptions.dart';

class ExceptionsHandler {
  static final ExceptionsHandler _singleton = new ExceptionsHandler._internal();

  factory ExceptionsHandler() {
    return _singleton;
  }

  ExceptionsHandler._internal();

  String checkErrorByCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return "Bad Request";
        break;
      case 401:
        return "am eroare cu codul 401";
        break;
      case 403:
        return "403 Forbidden";
        break;
      case 500:
        return "am eroare cu codul 500";
        break;
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${statusCode}');
    }
  }
}
