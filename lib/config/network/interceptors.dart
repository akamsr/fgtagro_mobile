// ignore_for_file: flutter_style_todos

import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fgtagro_mobile/utils/storage/local.storage.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      // Log only the path, not the full URL which may contain the domain
      log('REQUEST[${options.method}] => PATH: ${options.path}');
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log(
        'ERROR[${err.response?.statusCode}, ${err.response?.statusMessage}] => PATH: ${err.requestOptions.path}',
      );
    }
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      log(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
    }
    handler.next(response);
  }
}

class AuthenticationInterceptor extends Interceptor {
  String? get _token => locator<StorageServices>().accesToken;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Authorization'] = 'Bearer $_token';
    options.headers['Accept'] = 'application/json';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // TODO: Implement token refresh on 401
    if (kDebugMode) {
      log(
        err.response?.statusMessage.toString() ?? '',
        name: 'AUTH_ERROR',
      );
    }
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

    // Fixed bug: was `retryAttempts < retryAttempts` (always false).
    while (retryAttempts < retryCount && await _shouldRetry(err)) {
      try {
        retryAttempts++;
        if (kDebugMode) {
          log('Retrying request (attempt $retryAttempts of $retryCount)...');
        }
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
        if (e is DioException) {
          err = e;
        } else {
          break;
        }
      }
    }

    handler.next(err);
  }

  Future<bool> _shouldRetry(DioException err) async {
    // Do not retry API errors (4xx/5xx) — only connectivity-level failures
    if (err.response != null) return false;

    final List<ConnectivityResult> result =
        await Connectivity().checkConnectivity();
    final bool hasConnection = !result.contains(ConnectivityResult.none);

    final bool isRetryableError =
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.unknown;

    return isRetryableError && hasConnection;
  }
}

class ErrorHandlingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      // Log path only, never the full URL
      final path = err.requestOptions.path;
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
          log('Connection timeout for: $path');
          break;
        case DioExceptionType.sendTimeout:
          log('Send timeout for: $path');
          break;
        case DioExceptionType.receiveTimeout:
          log('Receive timeout for: $path');
          break;
        case DioExceptionType.badCertificate:
          log('Bad certificate for: $path');
          break;
        case DioExceptionType.badResponse:
          log('Bad response [${err.response?.statusCode}] for: $path');
          break;
        case DioExceptionType.cancel:
          log('Request cancelled: $path');
          break;
        case DioExceptionType.connectionError:
          log('Connection error for: $path');
          break;
        case DioExceptionType.unknown:
          log('Unknown error for: $path');
          break;
      }
    }
    handler.next(err);
  }
}
