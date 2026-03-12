import 'package:dio/dio.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'network_config.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(SharedPref prefs)
    : _dio = Dio(
        BaseOptions(
          baseUrl: NetworkConfig.baseUrl,
          receiveDataWhenStatusError: true,
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    // 👇 THIS PART IS THE MAGIC
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestUrl: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
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

  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) =>
      _dio.get(endpoint, queryParameters: params);

  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? params,
  }) => _dio.post(endpoint, data: data, queryParameters: params);

  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
  }) =>
      _dio.put(endpoint, data: data, queryParameters: params, options: options);

  Future<Response> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? params,
  }) => _dio.patch(endpoint, data: data, queryParameters: params);

  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? params,
  }) => _dio.delete(endpoint, data: data, queryParameters: params);
}
