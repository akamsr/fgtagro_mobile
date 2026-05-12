import 'package:dio/dio.dart';
import 'package:fgtagro_mobile/config/network/interceptors.dart';
import 'package:fgtagro_mobile/config/network/cache_interceptor.dart';
import 'package:fgtagro_mobile/env/url.dart';

class ApiClient {
  static String get _baseUrl => apiUrl;
  late Dio dio;
  late AuthenticationInterceptor _authInterceptor;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        responseType: ResponseType.json,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );

    dio.interceptors.add(LoggingInterceptor());
    // _authInterceptor = AuthenticationInterceptor();
    _authInterceptor = AuthenticationInterceptor();

    dio.interceptors.add(_authInterceptor);
    dio.interceptors.add(DioCacheInterceptor()); // Added the new caching interceptor
    dio.interceptors.add(RetryInterceptor(dio: dio));
    dio.interceptors.add(ErrorHandlingInterceptor());
  }

  // void updateToken({required String token, required String? refreshToken}) {
  //   _authInterceptor.updateToken(newToken: token, refreshToken: refreshToken);
  //   dio.interceptors.add(_authInterceptor);
  // }
}
