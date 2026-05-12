import 'package:equatable/equatable.dart';
import 'package:fgtagro_mobile/utils/error/app_error.dart';

/// Base state class for BLoC states with centralized error handling.
abstract class GlobalAppState extends Equatable {
  const GlobalAppState();

  /// The current failure in the state, if any.
  AppFailure? get error => null;

  @override
  List<Object?> get props => [...extraprops, error];

  /// Additional properties for Equatable.
  List<Object?> get extraprops;
}
