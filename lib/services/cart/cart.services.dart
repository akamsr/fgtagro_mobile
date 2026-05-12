import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fgtagro_mobile/config/network/api_client.dart';
import 'package:fgtagro_mobile/env/url.dart';
import 'package:fgtagro_mobile/models/cart.dart';
import 'package:fgtagro_mobile/utils/network/network.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';

class CartService {
  Future<Cart> getCart() async {
    try {
      final response = await locator<ApiClient>().dio.get(
        '${apiUrl}cart',
        options: Options(headers: await NetworkUtils.headers()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data is String ? jsonDecode(response.data) : response.data;
        return Cart.fromMap(body['data']);
      } else {
        final body = response.data is String ? jsonDecode(response.data) : response.data;
        throw body['message'] ?? 'Failed to fetch cart';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final respBody = e.response?.data is String ? jsonDecode(e.response?.data) : e.response?.data;
        throw respBody?["message"] ?? e.toString();
      }
      rethrow;
    }
  }

  Future<Cart> addToCart(String productId, int qty) async {
    try {
      final response = await locator<ApiClient>().dio.post(
        '${apiUrl}cart/add',
        options: Options(headers: await NetworkUtils.headers()),
        data: {
          'productId': productId,
          'qty': qty,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data is String ? jsonDecode(response.data) : response.data;
        return Cart.fromMap(body['data']);
      } else {
        final body = response.data is String ? jsonDecode(response.data) : response.data;
        throw body['message'] ?? 'Failed to add item to cart';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final respBody = e.response?.data is String ? jsonDecode(e.response?.data) : e.response?.data;
        throw respBody?["message"] ?? e.toString();
      }
      rethrow;
    }
  }

  Future<Cart> removeFromCart(int cartItemId) async {
    try {
      final response = await locator<ApiClient>().dio.delete(
        '${apiUrl}cart/items/$cartItemId',
        options: Options(headers: await NetworkUtils.headers()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data is String ? jsonDecode(response.data) : response.data;
        return Cart.fromMap(body['data']);
      } else {
        final body = response.data is String ? jsonDecode(response.data) : response.data;
        throw body['message'] ?? 'Failed to remove item from cart';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final respBody = e.response?.data is String ? jsonDecode(e.response?.data) : e.response?.data;
        throw respBody?["message"] ?? e.toString();
      }
      rethrow;
    }
  }

  Future<Cart> updateQuantity(int cartItemId, int qty) async {
    try {
      final response = await locator<ApiClient>().dio.patch(
        '${apiUrl}cart/items/$cartItemId',
        options: Options(headers: await NetworkUtils.headers()),
        data: {
          'qty': qty,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data is String ? jsonDecode(response.data) : response.data;
        return Cart.fromMap(body['data']);
      } else {
        final body = response.data is String ? jsonDecode(response.data) : response.data;
        throw body['message'] ?? 'Failed to update quantity';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final respBody = e.response?.data is String ? jsonDecode(e.response?.data) : e.response?.data;
        throw respBody?["message"] ?? e.toString();
      }
      rethrow;
    }
  }
}
