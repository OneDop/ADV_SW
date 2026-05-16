import 'package:advsw/models/message_model.dart';
import 'package:advsw/services/api_client.dart';

class MessageService {
  final ApiClient _apiClient = ApiClient();

  /// POST /api/messages/project/{projectId}
  Future<MessageResponse> sendMessage(int projectId, SendMessageRequest request) async {
    try {
      final response = await _apiClient.post(
        '/messages/project/$projectId',
        data: request.toJson(),
      );
      return MessageResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/messages/project/{projectId}
  Future<List<MessageResponse>> getProjectHistory(int projectId) async {
    try {
      final response = await _apiClient.get('/messages/project/$projectId');
      final List<dynamic> data = response.data;
      return data.map((json) => MessageResponse.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE /api/messages/{messageId}
  Future<void> deleteMessage(int messageId) async {
    try {
      await _apiClient.delete('/messages/$messageId');
    } catch (e) {
      rethrow;
    }
  }
}
