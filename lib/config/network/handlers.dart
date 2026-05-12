import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fgtagro_mobile/config/exceptions/app_exceptions.dart';
import 'package:fgtagro_mobile/utils/error/global_error_handling/models/failure.dart';
import 'package:fgtagro_mobile/utils/log/log.dart';

Future<Either<Failure, T>> futureHandler<T>(
  Future<T> Function() function,
) async {
  try {
    final T result = await function();
    return Right(result);
  } on AppException catch (e, stackTrace) {
    log(e.message, error: e, stackTrace: stackTrace);
    switch (e.type) {
      case ExceptionType.api:
        return Left(Failure.fromApi(e));
      case ExceptionType.network:
        return Left(
          Failure.network(
            stackTrace: stackTrace,
            message: e.message,
            code: e.code,
          ),
        );
      case ExceptionType.localStorage:
        return Left(
          Failure.localStorage(
            stackTrace: stackTrace,
            message: e.message,
            code: e.code,
          ),
        );
      case ExceptionType.generic:
      // ignore: unreachable_switch_default
      default:
        return Left(
          Failure.generic(
            stackTrace: stackTrace,
            message: e.message,
            code: e.code,
          ),
        );
    }
  } catch (e) {
    DevLog.show('An error occured $e');
    return Left(Failure.generic(message: e.toString()));
  }
}
