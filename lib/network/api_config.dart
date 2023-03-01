import 'package:dio/dio.dart';
import '../configs/debug_fns.dart';

/// Configuration Service for Dio
class ApiConfigService {
  /// Configuration Service for Dio
  ApiConfigService();
  Dio dio = Dio();

  /// make a request
  Dio $Request() {
    dio.options.baseUrl = baseUrl().toString();
    return dio;
  }

  /// Get link to website home
  String baseUrl() {
    return 'https://just-bored-default-rtdb.europe-west1.firebasedatabase.app/';
  }

  /// Set Headers
  Map<String, dynamic> setHeaders() {
    Map<String, dynamic> header = {};
    printOut("user-header $header");
    return header;
  }
}
