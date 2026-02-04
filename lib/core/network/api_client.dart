import 'package:dio/dio.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'network_config.dart';

class ApiClient {
  final Dio _dio;

  // ApiClient(SharedPreferences prefs)
  //   : _dio = Dio(
  //       BaseOptions(
  //         baseUrl: NetworkConfig.baseUrl,
  //         connectTimeout: NetworkConfig.timeout,
  //         receiveTimeout: NetworkConfig.timeout,
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Accept': 'application/json',
  //         },
  //       ),
  //     ) {
  //   // 🔐 Attach token automatically if exists
  //   _dio.interceptors.add(
  //     InterceptorsWrapper(
  //       onRequest: (options, handler) {
  //         final token = prefs.getString('access_token');

  //         if (token != null && token.isNotEmpty) {
  //           options.headers['Authorization'] = 'Bearer $token';
  //         }

  //         handler.next(options);
  //       },
  //     ),
  //   );
  // }

  ApiClient(SharedPref prefs)
    : _dio = Dio(
        BaseOptions(
          baseUrl: NetworkConfig.baseUrl,
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = prefs.getToken();

          print("TOKEN = $token");

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print("FINAL HEADERS = ${options.headers}");

          handler.next(options);
        },
      ),
    );
  }
  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    return await _dio.get(endpoint, queryParameters: params);
  }

  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    return await _dio.post(endpoint, data: data, queryParameters: params);
  }

  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    return await _dio.put(endpoint, data: data, queryParameters: params);
  }

  Future<Response> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    return await _dio.patch(endpoint, data: data, queryParameters: params);
  }

  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    return await _dio.delete(endpoint, data: data, queryParameters: params);
  }
}
