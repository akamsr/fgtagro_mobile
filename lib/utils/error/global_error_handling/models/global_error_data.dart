import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'error_mapping.dart';
import 'error_strings.dart';

class GlobalErrorData extends Equatable {
  final String? _errorMessage;

  final dynamic error;
  final StackTrace? stackTrace;
  final bool? reportToServer;
  final bool showToUser;

  const GlobalErrorData(
    this.error, {
    this.stackTrace,
    this.showToUser = true,
    this.reportToServer,
    String? errorMessage,
  }) : _errorMessage = errorMessage;

  ErrorType get errorType => getErrorType(error);
  String get errorMessage {
    if (_errorMessage != null) return _errorMessage;
    final detectedErrorType = errorType;

    if (detectedErrorType == ErrorType.FirebaseAuth) {
      assert(error is FirebaseAuthException);
      return getFirebaseErrorMessage((error as FirebaseAuthException).code);
    }

    if (detectedErrorType == ErrorType.NoConnection) {
      return 'No Connection';
    }

    return error?.toString() ?? "Unknown error occurred. Please try again.";
  }

  @override
  List<Object?> get props => [
    errorMessage,
    error,
    stackTrace,
    showToUser,
    reportToServer,
  ];
}
