import 'package:dio/dio.dart';

class DioClient {
  static Dio get instance {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://173.249.41.232:8000/api/v1', // New VPS IP Address
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );
    return dio;
  }
}
