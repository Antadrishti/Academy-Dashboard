import 'dart:convert';
import '../models/message.dart';
import 'api_service.dart';

class MessagingService {
  final ApiService _apiService = ApiService();

  Future<List<Conversation>> getConversations() async {
    final response = await _apiService.get('/messaging/conversations');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['conversations'] as List)
          .map((json) => Conversation.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch conversations');
    }
  }

  Future<List<Message>> getMessages(String userId) async {
    final response = await _apiService.get('/messaging/conversations/$userId');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['messages'] as List)
          .map((json) => Message.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch messages');
    }
  }

  Future<void> sendMessage(String toUserId, String content, {MessageType type = MessageType.message}) async {
    final response = await _apiService.post(
      '/messaging/send',
      body: {
        'to': toUserId,
        'content': content,
        'type': type.toString().split('.').last,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to send message');
    }
  }
}


