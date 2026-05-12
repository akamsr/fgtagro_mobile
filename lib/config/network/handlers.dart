import 'package:dartz/dartz.dart';
import 'package:fgtagro_mobile/utils/error/app_error.dart';

/// A utility to handle asynchronous operations and return an [Either] 
/// containing an [AppFailure] or the result [T].
Future<Either<AppFailure, T>> futureHandler<T>(
  Future<T> Function() function,
) async {
  try {
    final T result = await function();
    return Right(result);
  } catch (e, stackTrace) {
    final failure = ErrorMapper.map(e, stackTrace);
    return Left(failure);
  }
}
