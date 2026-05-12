part of 'auth.cubit.dart';

class AuthState extends GlobalAppState {
  final bool genLoading;
  final AppFailure? genError;
  final bool showError;
  final String loginMode; // 'phone' or 'email'
  final bool isBiometricEnabled;
  final String biometricType; // 'face_id' or 'fingerprint'
  final String? biometricError;
  final bool formSubmitted;
  final bool success; // general success flag for OTP/Password reset
  final UserModel? user;

  AuthState({
    this.genLoading = false,
    this.genError,
    this.showError = false,
    this.loginMode = 'phone',
    this.isBiometricEnabled = false,
    this.biometricType = 'fingerprint',
    this.biometricError,
    this.formSubmitted = false,
    this.success = false,
    this.user,
  });

  @override
  AppFailure? get error => genError;

  AuthState copyWith({
    bool? genLoading,
    AppFailure? genError,
    bool? showError,
    String? loginMode,
    bool? isBiometricEnabled,
    String? biometricType,
    String? biometricError,
    bool? formSubmitted,
    bool? success,
    UserModel? user,
  }) {
    return AuthState(
      genLoading: genLoading ?? this.genLoading,
      genError: genError, // Allow clearing error
      showError: showError ?? this.showError,
      loginMode: loginMode ?? this.loginMode,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      biometricType: biometricType ?? this.biometricType,
      biometricError: biometricError, // Allow clearing error
      formSubmitted: formSubmitted ?? this.formSubmitted,
      success: success ?? this.success,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get extraprops => [
        genLoading,
        genError,
        showError,
        loginMode,
        isBiometricEnabled,
        biometricType,
        biometricError,
        formSubmitted,
        success,
        user,
      ];
}
