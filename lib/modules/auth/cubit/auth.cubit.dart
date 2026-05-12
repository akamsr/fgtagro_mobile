import 'dart:async';

import 'package:fgtagro_mobile/models/user.dart';
import 'package:fgtagro_mobile/services/auth/auth.services.dart';
import 'package:fgtagro_mobile/utils/error/app_error.dart';
import 'package:fgtagro_mobile/utils/error/global_app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth.state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiService apiService;

  AuthCubit({ApiService? apiService})
    : apiService = apiService ?? ApiService(),
      super(AuthState());

  void setLoginMode(String mode) {
    emit(state.copyWith(loginMode: mode));
  }

  void emitLoading() {
    emit(
      state.copyWith(
        genLoading: true,
        genError: null,
        showError: false,
        success: false,
      ),
    );
  }

  void emitLoaded() {
    emit(state.copyWith(genLoading: false));
  }

  void emitError(dynamic e, StackTrace s) {
    emit(
      state.copyWith(
        genLoading: false,
        genError: ErrorMapper.map(e, s),
        showError: true,
      ),
    );
  }

  void emitBiometricError(String errorMsg) {
    emit(state.copyWith(biometricError: errorMsg));
  }

  void clearBiometricError() {
    emit(state.copyWith(biometricError: null));
  }

  Future<void> loginWithEmail(String email, String password) async {
    emitLoading();
    try {
      await apiService.login({'email': email, 'password': password});
      emitLoaded();
    } catch (e, s) {
      emitError(e, s);
    }
  }

  Future<void> loginWithPhone(String phone, String password) async {
    emitLoading();
    try {
      await apiService.login({'phone': phone, 'password': password});
      emitLoaded();
    } catch (e, s) {
      emitError(e, s);
    }
  }

  Future<void> loginWithBiometrics() async {
    emitLoading();
    clearBiometricError();
    try {
      // TODO: Implement actual biometric retrieval of stored credentials
      await Future.delayed(const Duration(seconds: 1));
      emitLoaded();
    } catch (e, s) {
      emitBiometricError("Biometric login failed");
      emitLoaded();
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneCode,
    required String phoneNumber,
    required String password,
    required bool acceptTerms,
  }) async {
    emitLoading();
    try {
      final payload = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_code': phoneCode,
        'phone_number': phoneNumber,
        'password': password,
      };

      await apiService.register(payload);
      emitLoaded();
    } catch (e, s) {
      emitError(e, s);
    }
  }

  Future<void> forgotPassword(String email) async {
    emitLoading();
    try {
      await apiService.forgotPassword(email);
      emit(state.copyWith(genLoading: false, success: true));
    } catch (e, s) {
      emitError(e, s);
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emitLoading();
    try {
      await apiService.resetPasswordOtp(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      emit(state.copyWith(genLoading: false, success: true));
    } catch (e, s) {
      emitError(e, s);
    }
  }

  Future<void> verifyEmail(String email, String token) async {
    emitLoading();
    try {
      // Currently using a generic API service if verify is not specifically mapped
      await Future.delayed(const Duration(seconds: 1));
      emitLoaded();
    } catch (e, s) {
      emitError(e, s);
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    emitLoading();
    try {
      // TODO: Implement API Call in ApiService for resend
      await Future.delayed(const Duration(seconds: 1));
      emitLoaded();
    } catch (e, s) {
      emitError(e, s);
    }
  }

  Future<void> logout() async {
    emit(AuthState());
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}
