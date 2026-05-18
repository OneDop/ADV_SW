import 'package:advsw/models/notification_model.dart';
import 'package:advsw/services/api_client.dart';

class NotificationService {
  final ApiClient _apiClient;

  NotificationService(this._apiClient);

  /// GET /api/notifications
  Future<List<NotificationResponse>> getNotificationsForUser() async {
    try {
      final response = await _apiClient.get('/notifications');
      final List<dynamic> data = response.data;
      return data.map((json) => NotificationResponse.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE /api/notifications/{id}
  Future<void> deleteNotification(int id) async {
    try {
      await _apiClient.delete('/notifications/$id');
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE /api/notifications
  Future<void> deleteAllNotifications() async {
    try {
      await _apiClient.delete('/notifications');
    } catch (e) {
      rethrow;
    }
  }
}
