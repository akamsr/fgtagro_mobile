import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

enum FailureType { network, server, auth, validation, cache, unknown }

/// Unified error model for the application.
class AppFailure extends Equatable {
  final String id;
  final FailureType type;
  final String message;
  final String? technicalDetails;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final bool reportable;

  AppFailure({
    required this.type,
    required this.message,
    this.technicalDetails,
    this.originalError,
    this.stackTrace,
    this.reportable = true,
    String? id,
  }) : id = id ?? const Uuid().v4();

  @override
  List<Object?> get props => [id, type, message, technicalDetails, reportable];
}

/// Centralized mapper to convert any error into an [AppFailure].
class ErrorMapper {
  ErrorMapper._();

  static AppFailure map(dynamic error, [StackTrace? stackTrace]) {
    if (error is AppFailure) return error;

    if (error is FirebaseAuthException) return _mapAuth(error, stackTrace);
    if (error is DioException) return _mapDio(error, stackTrace);
    if (_isNetwork(error)) return _network(error, stackTrace);

    return AppFailure(
      type: FailureType.unknown,
      message: 'An unexpected error occurred.',
      technicalDetails: _sanitize(error.toString()),
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  static AppFailure _mapAuth(FirebaseAuthException e, StackTrace? s) {
    String msg = 'Authentication failed.';
    switch (e.code) {
      case 'user-not-found':
        msg = 'No user found with this email.';
        break;
      case 'wrong-password':
        msg = 'Incorrect password.';
        break;
      case 'email-already-in-use':
        msg = 'Account already exists.';
        break;
      case 'network-request-failed':
        return _network(e, s);
    }
    return AppFailure(
      type: FailureType.auth,
      message: msg,
      technicalDetails: e.code,
      originalError: e,
      stackTrace: s,
    );
  }

  static AppFailure _mapDio(DioException e, StackTrace? s) {
    if (e.response != null) {
      final data = e.response?.data;
      String msg = 'Server error.';
      if (data is Map)
        msg = data['message'] ?? data['error']?['message'] ?? msg;
      return AppFailure(
        type: FailureType.server,
        message: msg,
        technicalDetails: 'Status: ${e.response?.statusCode}',
        originalError: e,
        stackTrace: s,
      );
    }
    return _network(e, s);
  }

  static AppFailure _network(dynamic e, StackTrace? s) => AppFailure(
    type: FailureType.network,
    message: 'No internet connection.',
    technicalDetails: _sanitize(e.toString()),
    originalError: e,
    stackTrace: s,
  );

  static bool _isNetwork(dynamic e) {
    if (e is SocketException || e is TimeoutException) return true;
    if (e is DioException && e.response == null) return true;
    return e.toString().toLowerCase().contains('socketexception');
  }

  static String _sanitize(String raw) {
    return raw
        .replaceAll(RegExp(r'https?://\S+'), '[redacted]')
        .replaceAll(
          RegExp(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(:\d+)?\b'),
          '[redacted]',
        );
  }
}
