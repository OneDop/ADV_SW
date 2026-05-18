import 'package:advsw/mock/mock_data.dart';
import 'package:advsw/models/notification_model.dart';

class NotificationService {
  Future<List<NotificationResponse>> getNotificationsForUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(MockData.notifications);
  }

  Future<void> deleteNotification(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    MockData.notifications.removeWhere((n) => n.id == id);
  }

  Future<void> deleteAllNotifications() async {
    await Future.delayed(const Duration(milliseconds: 200));
    MockData.notifications.clear();
  }
}
