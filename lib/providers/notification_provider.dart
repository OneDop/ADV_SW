import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/models/notification_model.dart';
import 'package:advsw/services/notification_service.dart';

/// Provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// AsyncNotifier to manage the user's notifications
class NotificationsNotifier extends AsyncNotifier<List<NotificationResponse>> {
  @override
  FutureOr<List<NotificationResponse>> build() async {
    return ref.watch(notificationServiceProvider).getNotificationsForUser();
  }

  /// Refresh the notifications list from the server
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(notificationServiceProvider).getNotificationsForUser());
  }

  /// Delete a specific notification
  Future<void> deleteNotification(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(notificationServiceProvider).deleteNotification(id);
      final currentNotifications = state.value ?? [];
      return currentNotifications.where((n) => n.id != id).toList();
    });
  }

  /// Delete all notifications
  Future<void> deleteAllNotifications() async {
    state = await AsyncValue.guard(() async {
      await ref.read(notificationServiceProvider).deleteAllNotifications();
      return [];
    });
  }
}

/// Provider for the current user's notifications
final notificationsProvider = AsyncNotifierProvider<NotificationsNotifier, List<NotificationResponse>>(NotificationsNotifier.new);
