// import 'package:dio/dio.dart';
// import 'network_config.dart';

// class ApiClient {
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: NetworkConfig.baseUrl,
//       connectTimeout: NetworkConfig.timeout,
//       receiveTimeout: NetworkConfig.timeout,
//     ),
//   );

//   Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
//     return await _dio.get(endpoint, queryParameters: params);
//   }

//   Future<Response> post(String endpoint, {dynamic data}) async {
//     return await _dio.post(endpoint, data: data);
//   }
  
// }

import 'package:dio/dio.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'network_config.dart';

class ApiClient {
  final Dio _dio;

  // ApiClient({String? token})
  //     : _dio = Dio(
  //         BaseOptions(
  //           baseUrl: NetworkConfig.baseUrl,
  //           connectTimeout: NetworkConfig.timeout,
  //           receiveTimeout: NetworkConfig.timeout,
  //           headers: token != null
  //               ? {
  //                   'Authorization': 'Bearer $token',
  //                   'Content-Type': 'application/json',
  //                 }
  //               : {
  //                   'Content-Type': 'application/json',
  //                 },
  //         ),
  //       );
    ApiClient(SharedPref prefs)
      : _dio = Dio(
          BaseOptions(
            baseUrl: NetworkConfig.baseUrl,
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        ) {   
    // 👇 THIS PART IS THE MAGIC
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
}

     ),
    );
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    return await _dio.get(endpoint, queryParameters: params);
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    return await _dio.put(endpoint, data: data);
  }

  Future<Response> patch(String endpoint, {dynamic data}) async {
    return await _dio.patch(endpoint, data: data);
  }

  Future<Response> delete(String endpoint, {dynamic data}) async {
    return await _dio.delete(endpoint, data: data);
  }

  // void updateToken(String token) {
  //   _dio.options.headers['Authorization'] = 'Bearer $token';
  // }
}
