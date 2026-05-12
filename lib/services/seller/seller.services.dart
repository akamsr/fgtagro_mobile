import 'dart:convert';
import 'package:fgtagro_mobile/env/url.dart';
import 'package:fgtagro_mobile/models/seller.dart';
import 'package:fgtagro_mobile/utils/network/network.dart';
import 'package:dio/dio.dart';
import 'package:fgtagro_mobile/config/network/api_client.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';

class SellerService {
  Future<SellerProfileModel> onboardSeller(Map<String, dynamic> data) async {
    final response = await locator<ApiClient>().dio.post(
      '${apiUrl}sellers/onboard',
      options: Options(headers: await NetworkUtils.headers()),
      data: data,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      return SellerProfileModel.fromJson(body['data']);
    } else {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      throw body['message'] ?? 'Failed to onboard seller';
    }
  }

  Future<SellerProfileModel> getSellerProfile() async {
    final response = await locator<ApiClient>().dio.get(
      '${apiUrl}sellers/me',
      options: Options(headers: await NetworkUtils.headers()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      return SellerProfileModel.fromJson(body['data']);
    } else {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      throw body['message'] ?? 'Failed to fetch seller profile';
    }
  }

  Future<List<StoreModel>> getMyStores() async {
    final response = await locator<ApiClient>().dio.get(
      '${apiUrl}sellers/me/stores',
      options: Options(headers: await NetworkUtils.headers()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      final data = body['data'] as List;
      return data.map((e) => StoreModel.fromJson(e)).toList();
    } else {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      throw body['message'] ?? 'Failed to fetch stores';
    }
  }

  Future<StoreModel> createStore(Map<String, dynamic> data) async {
    final response = await locator<ApiClient>().dio.post(
      '${apiUrl}sellers/me/stores',
      options: Options(headers: await NetworkUtils.headers()),
      data: data,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      return StoreModel.fromJson(body['data']);
    } else {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      throw body['message'] ?? 'Failed to create store';
    }
  }
}
