import 'dart:convert';
import 'package:fgtagro_mobile/env/url.dart';
import 'package:fgtagro_mobile/models/conversation.dart';
import 'package:fgtagro_mobile/models/message.dart';
import 'package:fgtagro_mobile/utils/network/network.dart';
import 'package:dio/dio.dart';
import 'package:fgtagro_mobile/config/network/api_client.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';

class ConversationService {
  Future<List<ConversationModel>> getConversations() async {
    final response = await locator<ApiClient>().dio.get(
      '${apiUrl}conversations',
      options: Options(headers: await NetworkUtils.headers()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      final data = body['data'] as List;
      return data.map((e) => ConversationModel.fromJson(e)).toList();
    } else {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      throw body['message'] ?? 'Failed to fetch conversations';
    }
  }

  Future<List<MessageModel>> getMessages(String conversationId) async {
    final response = await locator<ApiClient>().dio.get(
      '${apiUrl}conversations/$conversationId/messages',
      options: Options(headers: await NetworkUtils.headers()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      final data = body['data'] as List;
      return data.map((e) => MessageModel.fromJson(e)).toList();
    } else {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      throw body['message'] ?? 'Failed to fetch messages';
    }
  }

  Future<MessageModel> sendMessage(String conversationId, String content, {String? image}) async {
    final response = await locator<ApiClient>().dio.post(
      '${apiUrl}conversations/$conversationId/messages',
      options: Options(headers: await NetworkUtils.headers()),
      data: {
        'content': content,
        if (image != null) 'image': image,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      return MessageModel.fromJson(body['data']);
    } else {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      throw body['message'] ?? 'Failed to send message';
    }
  }
}
