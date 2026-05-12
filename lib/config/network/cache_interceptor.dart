import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fgtagro_mobile/models/cache/cache_record.dart';
import 'package:fgtagro_mobile/utils/storage/hive.storage.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';

class DioCacheInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // We only cache GET requests
    if (options.method != 'GET') {
      return handler.next(options);
    }

    final connectivityResult = await Connectivity().checkConnectivity();
    // In connectivity_plus > 5.0, it returns a List<ConnectivityResult>
    final bool isOffline = connectivityResult.contains(ConnectivityResult.none) || 
                           connectivityResult.isEmpty;

    final bool isCacheFirst = options.headers['cache-strategy'] == 'cache-first' ||
                              options.extra['cache-first'] == true;

    if (isOffline || isCacheFirst) {
      final cacheRecord = await locator<HiveDbService>().getApiCache(options.uri.toString());

      if (cacheRecord != null && cacheRecord.isValid) {
        // Return cached response
        return handler.resolve(
          Response(
            requestOptions: options,
            data: jsonDecode(cacheRecord.responseData),
            statusCode: 200,
            statusMessage: 'OK (Cached)',
            headers: cacheRecord.headers != null 
                ? Headers.fromMap(
                    cacheRecord.headers!.map((k, v) => MapEntry(k, List<String>.from(v))),
                  ) 
                : null,
          ),
          true, // resolve locally
        );
      } else if (isOffline) {
        // Offline and no valid cache
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
            error: 'No internet connection and no cached data available.',
          ),
          true,
        );
      }
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.method == 'GET' && 
        (response.statusCode == 200 || response.statusCode == 201)) {
      
      try {
        final cacheRecord = CacheRecord(
          url: response.requestOptions.uri.toString(),
          responseData: jsonEncode(response.data),
          timestamp: DateTime.now(),
          headers: response.headers.map,
        );

        await locator<HiveDbService>().saveApiCache(
          response.requestOptions.uri.toString(), 
          cacheRecord,
        );
      } catch (e) {
        // Ignore JSON encoding errors for non-JSON responses
      }
    }
    
    return handler.next(response);
  }
}
