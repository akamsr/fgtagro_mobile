import 'dart:convert';
import 'package:fgtagro_mobile/env/url.dart';
import 'package:fgtagro_mobile/models/category.dart';
import 'package:fgtagro_mobile/models/product.dart';
import 'package:fgtagro_mobile/utils/log/log.dart';
import 'package:fgtagro_mobile/utils/network/network.dart';
import 'package:dio/dio.dart';
import 'package:fgtagro_mobile/config/network/api_client.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';

class ProductService {
  Future<List<CategoryModel>> getCategories() async {
    final response = await locator<ApiClient>().dio.get(
      '${apiUrl}categories',
      options: Options(
        headers: await NetworkUtils.headers(),
        extra: {'cache-first': true},
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      final data = body['data'] as List;
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } else {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      throw body['message'] ?? 'Failed to fetch categories';
    }
  }

  Future<ProductModel> getProductById(String id) async {
    final response = await locator<ApiClient>().dio.get(
      '${apiUrl}products/$id',
      options: Options(headers: await NetworkUtils.headers()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      return ProductModel.fromJson(body['data']);
    } else {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      throw body['message'] ?? 'Failed to fetch product details';
    }
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    final response = await locator<ApiClient>().dio.get(
      '${apiUrl}products/featured/list',
      options: Options(headers: await NetworkUtils.headers()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      final data = body['data'] as List;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      throw body['message'] ?? 'Failed to fetch featured products';
    }
  }

  Future<Map<String, dynamic>> getPublishedProducts({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    String uri = '${apiUrl}products?page=$page&limit=$limit';
    if (search != null && search.isNotEmpty) {
      uri += '&search=$search';
    }

    final response = await locator<ApiClient>().dio.get(
      uri,
      options: Options(headers: await NetworkUtils.headers()),
    );

    DevLog.show("response: $response");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data;
          
      final data = body['data'] is List 
          ? body['data'] as List 
          : (body['data']?['data'] as List? ?? []);
          
      final products = data.map((e) => ProductModel.fromJson(e)).toList();
      final total = body['pagination']?['total'] ?? body['data']?['total'] ?? 0;
      
      return {'products': products, 'total': total};
    } else {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      throw body['message'] ?? 'Failed to fetch products';
    }
  }

  Future<Map<String, dynamic>> getProductsByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await locator<ApiClient>().dio.get(
      '${apiUrl}products/category/$categoryId?page=$page&limit=$limit',
      options: Options(headers: await NetworkUtils.headers()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data;
          
      final data = body['data'] is List 
          ? body['data'] as List 
          : (body['data']?['data'] as List? ?? []);
          
      final products = data.map((e) => ProductModel.fromJson(e)).toList();
      final total = body['pagination']?['total'] ?? body['data']?['total'] ?? 0;
      
      return {'products': products, 'total': total};
    } else {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      throw body['message'] ?? 'Failed to fetch category products';
    }
  }
}
