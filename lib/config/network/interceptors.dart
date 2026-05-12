// ignore_for_file: flutter_style_todos

import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fgtagro_mobile/utils/storage/local.storage.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("REQUEST[${options.method}] => PATH: ${options.path}");

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      'ERROR[${err.response?.statusCode}, ${err.response?.statusMessage}] => PATH: ${err.requestOptions.path}',
    );
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    handler.next(response);
  }
}

class AuthenticationInterceptor extends Interceptor {
  // final Dio _dio;

  // String? _refreshToken;

  String? get _token => locator<StorageServices>().accesToken;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers["Authorization"] = "Bearer $_token";
    options.headers["Accept"] = "application/json";
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    //Todo: Refresh authentication token if response id 401 (or 500 - to be fixed)
    if (err.response?.statusCode == 401 || err.response?.statusCode == 500) {
      // if(err.response.statusCode==401&&err.response.data['message'])
      // push(const DriverLoginRoute());
      // final String? newToken = await refreshAccessToken();
      // if (newToken != null) {
      //   err.requestOptions.headers["Not Authorized"] = "Bearer $newToken";

      //   ///Gets the new token gotten after refresh and updates the old token stored in the local db;

      //   // updateToken(newToken: newToken);
      //   return handler.resolve(await _dio.fetch(err.requestOptions));
      // }
    }
    log(err.response?.statusMessage.toString() ?? "", name: 'ERROR');

    handler.next(err);
  }
}

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retryCount;

  RetryInterceptor({required this.dio, this.retryCount = 3});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    int retryAttempts = 0;

    while (retryAttempts < retryAttempts && await _shouldRetry(err)) {
      try {
        retryAttempts++;
        final Response response = await dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          onSendProgress: err.requestOptions.onSendProgress,
          onReceiveProgress: err.requestOptions.onReceiveProgress,
          cancelToken: err.requestOptions.cancelToken,
        );

        handler.resolve(response);
        return;
      } catch (e) {
        err = e as DioException;
      }
    }

    handler.next(err);
  }

  Future<bool> _shouldRetry(DioException err) async {
    final List<ConnectivityResult> result = await Connectivity()
        .checkConnectivity();
    final bool shouldRetry =
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.unknown &&
            !result.contains(ConnectivityResult.none);

    return shouldRetry;
  }
}

class ErrorHandlingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        log("Connection timeout with ${err.requestOptions.path}");
        log(
          err.message ?? "Connection timeout with ${err.requestOptions.path}",
        );
        break;
      case DioExceptionType.sendTimeout:
        log("Send timeout in connection with ${err.requestOptions.path}");
        log(
          err.message ??
              "Send timeout in connection with ${err.requestOptions.path}",
        );
        break;
      case DioExceptionType.receiveTimeout:
        log("Receive timeout with ${err.requestOptions.path}");
        log(err.message ?? "Receive timeout with ${err.requestOptions.path}");
        break;
      case DioExceptionType.badCertificate:
        log("Received Bad Certificate error from ${err.requestOptions.path}");
        log(
          err.message ??
              "Bad Certificate error from ${err.requestOptions.path}",
        );
        break;
      case DioExceptionType.badResponse:
        log(
          "Bad Response: ${err.response?.statusCode} from ${err.requestOptions.path}",
        );
        log(
          err.response?.data?.toString() ??
              err.message ??
              err.response?.statusMessage ??
              "Bad Response: ${err.response?.statusCode} from ${err.requestOptions.path}",
        );
        break;
      case DioExceptionType.cancel:
        log("Request to ${err.requestOptions.path} was cancelled");
        log(
          err.message ?? "Request to ${err.requestOptions.path} was cancelled",
        );
        break;
      case DioExceptionType.connectionError:
        log(
          "Connection Error, No Internet or Something Else to send request to ${err.requestOptions.path}",
        );
        log(
          err.message ??
              "Connection Error, No Internet or Something Else to send request to ${err.requestOptions.path}",
        );

      case DioExceptionType.unknown:
        log(
          "An Unknown error occurred when sending request to ${err.requestOptions.path}",
        );
    }

    handler.next(err);
  }
}
