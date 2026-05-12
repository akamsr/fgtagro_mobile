// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:fgtagro_mobile/env/url.dart';
import 'package:fgtagro_mobile/models/user.dart';
import 'package:fgtagro_mobile/utils/language/language.dart';
import 'package:fgtagro_mobile/utils/log/log.dart';
import 'package:fgtagro_mobile/utils/network/network.dart';
import 'package:fgtagro_mobile/utils/storage/local.storage.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:fgtagro_mobile/widgets/notification/toast.dart';
import 'package:flutter/material.dart';
import '../../utils/functions/navigate.dart';

import 'package:dio/dio.dart';
import 'package:fgtagro_mobile/config/network/api_client.dart';

import 'firebase.provider.auth.dart';

class ApiService {
  final storageService = locator<StorageServices>();
  final firebase = FirebaseProvider();

  Future<String> updateUser(UserModel user) async {
    final url =
        '${apiUrl}update-user/${user.uid}?lang=${LanguageService.current}';
    final body = jsonEncode(user.toJson());
    try {
      final response = await locator<ApiClient>().dio.put(
        url,
        options: Options(headers: NetworkUtils.headers()),
        data: body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        await storageService.saveModel(
          key: 'loggedUser',
          value: user.toJsonString(),
        );
        await storageService.saveModel(
          key: 'loggedUser',
          value: user.toJsonString(),
        );
        return 'Success';
      } else {
        final respBody = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        throw Exception(respBody["message"]);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final respBody = e.response?.data is String
            ? jsonDecode(e.response?.data)
            : e.response?.data;
        return respBody?["message"] ?? e.toString();
      }
      return e.toString();
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      return 'Failed to update user. Please try again.';
    }
  }

  Future<UserModel?> login(Map<String, dynamic> data) async {
    try {
      final response = await locator<ApiClient>().dio.post(
        "${apiUrl}auth/login",
        options: Options(headers: NetworkUtils.headers()),
        data: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        final user = UserModel.fromJson(
          body['data']['user'] ?? body['user'] ?? body,
        );
        final token = body['data']['access_token'] ?? body['access_token'];

        if (token != null) {
          await storageService.prefs.setString('token', token);
        }
        await storageService.saveModel(
          key: 'loggedUser',
          value: user.toJsonString(),
        );
        await storageService.prefs.setInt('userId', user.id ?? 0);

        return user;
      } else {
        final body = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        throw body['error']?['message'] ?? body['message'] ?? 'Login failed';
      }
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body != null) {
        final parsed = body is String ? jsonDecode(body) : body;
        throw parsed['error']?['message'] ??
            parsed['message'] ??
            'Login failed';
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> register(Map<String, dynamic> data) async {
    try {
      final response = await locator<ApiClient>().dio.post(
        "${apiUrl}auth/register",
        options: Options(headers: NetworkUtils.headers()),
        data: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final userData = body['data']?['user'] ?? body['user'] ?? body;
        final user = UserModel.fromJson(userData);

        final token = body['data']?['access_token'] ?? body['access_token'];

        if (token != null) {
          await storageService.prefs.setString('token', token);
        }
        await storageService.saveModel(
          key: 'loggedUser',
          value: user.toJsonString(),
        );
        await storageService.prefs.setInt('userId', user.id ?? 0);

        return user;
      } else {
        final body = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        throw body['error']?['message'] ??
            body['message'] ??
            'Registration failed';
      }
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body != null) {
        final parsed = body is String ? jsonDecode(body) : body;
        throw parsed['error']?['message'] ??
            parsed['message'] ??
            'Registration failed';
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      final response = await locator<ApiClient>().dio.post(
        "${apiUrl}auth/forgot-password",
        options: Options(headers: NetworkUtils.headers()),
        data: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final body = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        throw body['error']?['message'] ??
            body['message'] ??
            'Forgot password failed';
      }
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body != null) {
        final parsed = body is String ? jsonDecode(body) : body;
        throw parsed['error']?['message'] ??
            parsed['message'] ??
            'Forgot password failed';
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPasswordOtp({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await locator<ApiClient>().dio.post(
        "${apiUrl}auth/reset-password-otp",
        options: Options(headers: NetworkUtils.headers()),
        data: jsonEncode({
          'email': email,
          'otp': otp,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final body = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        throw body['error']?['message'] ??
            body['message'] ??
            'Reset password failed';
      }
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body != null) {
        final parsed = body is String ? jsonDecode(body) : body;
        throw parsed['error']?['message'] ??
            parsed['message'] ??
            'Reset password failed';
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> verifyEmail(String email, String token) async {
    try {
      final response = await locator<ApiClient>().dio.post(
        "${apiUrl}auth/verify-otp",
        options: Options(headers: NetworkUtils.headers()),
        data: jsonEncode({'email': email, 'token': token}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final body = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        throw body['error']?['message'] ??
            body['message'] ??
            'Email verification failed';
      }
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body != null) {
        final parsed = body is String ? jsonDecode(body) : body;
        throw parsed['error']?['message'] ??
            parsed['message'] ??
            'Email verification failed';
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      final response = await locator<ApiClient>().dio.post(
        "${apiUrl}auth/resend-verification",
        options: Options(headers: NetworkUtils.headers()),
        data: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final body = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        throw body['error']?['message'] ?? body['message'] ?? 'Resend failed';
      }
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body != null) {
        final parsed = body is String ? jsonDecode(body) : body;
        throw parsed['error']?['message'] ??
            parsed['message'] ??
            'Resend failed';
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // --- End of new REST endpoints ---

  Future<UserModel?> getUserById(int id) async {
    final Map data = {"uid": id};
    final response = await locator<ApiClient>().dio.post(
      "${apiUrl}users/find/$id?lang=${LanguageService.current}",
      options: Options(headers: NetworkUtils.headers()),
      data: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      return UserModel.fromJson(body);
    } else {
      throw Exception("User not found");
    }
  }

  Future<UserModel?> getAuthUser(String userID) async {
    final response = await locator<ApiClient>().dio.get(
      "${apiUrl}auth/me?lang=${LanguageService.current}",
      options: Options(headers: NetworkUtils.headers()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      return UserModel.fromJson(
        body['data']?['user'] ?? body['user'] ?? body['data'] ?? body,
      );
    } else {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      throw body;
    }
  }

  Future<UserModel?> refreshUserToken() async {
    try {
      final response = await locator<ApiClient>().dio.post(
        "${apiUrl}auth/refresh?lang=${LanguageService.current}",
        options: Options(headers: NetworkUtils.headers()),
        data: jsonEncode({
          'refresh_token': locator<StorageServices>().refreshToken,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        final user = UserModel.fromJson(body);
        await storageService.saveModel(
          key: 'loggedUser',
          value: user.toJsonString(),
        );
        await storageService.prefs.setInt('userId', user.id ?? 0);
        await storageService.prefs.setString('token', user.token ?? '');
        return user;
      } else {
        logout();
        return null;
      }
    } catch (e) {
      logout();
      return null;
    }
  }

  void logout() async {
    await locator<StorageServices>().prefs.remove('businessId');
    await locator<StorageServices>().prefs.remove('userId');
    await locator<StorageServices>().prefs.remove('isFirstTimeBuzpay');
    await locator<StorageServices>().prefs.remove('token');
    locator<StorageServices>().clearModel(key: 'loggedUser');
    CustomNavigate().changeIndex(0);
  }
}
