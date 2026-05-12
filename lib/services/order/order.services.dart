import 'dart:convert';
import 'package:fgtagro_mobile/env/url.dart';
import 'package:fgtagro_mobile/models/order.dart';
import 'package:fgtagro_mobile/utils/network/network.dart';
import 'package:dio/dio.dart';
import 'package:fgtagro_mobile/config/network/api_client.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';

class OrderService {
  Future<List<OrderModel>> getOrders() async {
    final response = await locator<ApiClient>().dio.get(
      '${apiUrl}orders',
      options: Options(headers: await NetworkUtils.headers()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      final data = body['data'] as List;
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      throw body['message'] ?? 'Failed to fetch orders';
    }
  }

  Future<OrderModel> getOrderById(String id) async {
    final response = await locator<ApiClient>().dio.get(
      '${apiUrl}orders/$id',
      options: Options(headers: await NetworkUtils.headers()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      return OrderModel.fromJson(body['data']);
    } else {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      throw body['message'] ?? 'Failed to fetch order details';
    }
  }
}
