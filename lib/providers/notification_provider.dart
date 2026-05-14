import 'dart:async';
import 'package:riverpod/riverpod.dart';
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
}

/// Provider for the current user's notifications
final notificationsProvider = AsyncNotifierProvider<NotificationsNotifier, List<NotificationResponse>>(NotificationsNotifier.new);
