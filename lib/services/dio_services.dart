import 'package:dio/dio.dart';

class DioServices {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8000/api',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
