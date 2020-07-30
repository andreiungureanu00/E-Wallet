import 'dart:html';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ReportsRepository {
  static final ReportsRepository _singleton = new ReportsRepository._internal();

  factory ReportsRepository() {
    return _singleton;
  }

  ReportsRepository._internal();

  String path;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
}
