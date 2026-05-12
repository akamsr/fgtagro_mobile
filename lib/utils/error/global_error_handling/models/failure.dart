import 'package:equatable/equatable.dart';
import 'package:fgtagro_mobile/config/exceptions/app_exceptions.dart';

class Failure extends Equatable {
  final String? message;
  final String? debugMessage;
  final String? code;
  final StackTrace? stackTrace;

  const Failure({this.message, this.debugMessage, this.code, this.stackTrace});

  const Failure.generic({
    this.message = "An error has occurred",
    this.stackTrace = null,
    this.code,
    this.debugMessage,
  });
  const Failure.network({
    this.message = "No internet, try connecting to a network",
    this.stackTrace = null,
    this.code,
    this.debugMessage,
  });
  const Failure.api({
    this.message = "No internet, try connecting to a network",
    this.stackTrace = null,
    this.code,
    this.debugMessage,
  });
  const Failure.localStorage({
    this.message = "No internet, try connecting to a network",
    this.stackTrace = null,
    this.code,
    this.debugMessage,
  });

  factory Failure.fromApi(AppException exception) {
    if (exception.code != null) {
      if (exception.code!.startsWith('4')) {
        return Failure.api(
          message: exception.message.isNotEmpty
              ? exception.message
              : "Not Found",
          code: exception.code,
        );
      }

      if (exception.code!.startsWith('5')) {
        return Failure.api(
          message: exception.message.isNotEmpty
              ? exception.message
              : "Internal Server Error",
          code: exception.code,
        );
      }

      if (exception.code!.startsWith('3')) {
        return Failure.api(
          message: exception.message.isNotEmpty
              ? exception.message
              : "Bad Request",
          code: exception.code,
        );
      }

      if (exception.code!.startsWith('2')) {
        return Failure.api(
          message: exception.message.isNotEmpty ? exception.message : "OK",
          code: exception.code,
        );
      }

      if (exception.code!.startsWith('1')) {
        return Failure.api(
          message: exception.message.isNotEmpty
              ? exception.message
              : "Not Implemented",
          code: exception.code,
        );
      }
    } else {
      return Failure.api(
        message: exception.message.isNotEmpty
            ? exception.message
            : "An unknown API error has occurred",
        code: exception.code,
      );
    }
    return Failure.api(
      message: exception.message.isNotEmpty
          ? exception.message
          : "An unknown API error has occurred",
      code: exception.code,
    );
  }
  @override
  List<Object?> get props => [message, code, debugMessage];
}
