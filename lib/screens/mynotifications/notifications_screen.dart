import 'package:advsw/models/notification_model.dart';
import 'package:advsw/providers/notification_provider.dart';
import 'package:advsw/providers/invitation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/theme/app_theme.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Updates', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.4)),
                  notificationsAsync.when(
                    data: (notifs) => Text('${notifs.length} new', style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
                    loading: () => const Text('Loading...', style: TextStyle(fontSize: 11, color: AppColors.ink500)),
                    error: (_, __) => const Text('Error', style: TextStyle(fontSize: 11, color: AppColors.ink500)),
                  ),
                ])),
                GestureDetector(
                  onTap: () => ref.read(notificationsProvider.notifier).deleteAllNotifications(),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.line), boxShadow: AppTheme.shadowSm,
                    ),
                    child: const Icon(Icons.done_all_rounded, size: 20, color: AppColors.ink700),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: notificationsAsync.when(
              data: (notifs) {
                if (notifs.isEmpty) return _EmptyState();
                
                return RefreshIndicator(
                  onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                    itemCount: notifs.length,
                    itemBuilder: (_, i) => _NotifItem(
                      n: notifs[i], 
                      onDismiss: () => ref.read(notificationsProvider.notifier).deleteNotification(notifs[i].id),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _NotifItem extends ConsumerWidget {
  final NotificationResponse n;
  final VoidCallback onDismiss;

  const _NotifItem({required this.n, required this.onDismiss});

  ({Color bg, Color fg}) get _tone {
    switch (n.type) {
      case NotificationType.TASK_ASSIGNED:
        return (bg: AppColors.teal50, fg: AppColors.teal700);
      case NotificationType.MESSAGE_RECEIVED:
        return (bg: const Color(0xFFE8F4FA), fg: const Color(0xFF0E5B85));
      case NotificationType.PROJECT_UPDATE:
        return (bg: AppColors.warm100, fg: AppColors.warm700);
      case NotificationType.RATING_RECEIVED:
        return (bg: AppColors.success100, fg: AppColors.success700);
      case NotificationType.INVITATION:
      case NotificationType.JOIN_REQUEST:
        return (bg: const Color(0xFFF1ECFB), fg: const Color(0xFF5A399E));
    }
  }

  String get _displayTitle {
    switch (n.type) {
      case NotificationType.INVITATION: return 'Project Invitation';
      case NotificationType.JOIN_REQUEST: return 'Join Request';
      case NotificationType.TASK_ASSIGNED: return 'Task Assigned';
      case NotificationType.MESSAGE_RECEIVED: return 'New Message';
      case NotificationType.PROJECT_UPDATE: return 'Project Update';
      case NotificationType.RATING_RECEIVED: return 'New Rating';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = _tone;
    final bool isActionable = n.type == NotificationType.INVITATION || n.type == NotificationType.JOIN_REQUEST;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lineSoft), boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: t.bg, borderRadius: BorderRadius.circular(12)),
              child: Icon(
                isActionable ? Icons.person_add_outlined : Icons.notifications_outlined, 
                size: 18, 
                color: t.fg
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_displayTitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.ink900)),
              const SizedBox(height: 2),
              Text(n.message, style: const TextStyle(fontSize: 12, color: AppColors.ink700, height: 1.4)),
              const SizedBox(height: 6),
              Text('${n.createdAt.day}/${n.createdAt.month} • ${n.createdAt.hour}:${n.createdAt.minute.toString().padLeft(2, '0')}', 
                style: const TextStyle(fontSize: 10, color: AppColors.ink500)),
            ])),
            GestureDetector(
              onTap: onDismiss,
              child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.close_rounded, size: 16, color: AppColors.ink400)),
            ),
          ]),
          if (isActionable) ...[
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _ActionButton(
                  label: 'Reject',
                  onTap: () => ref.read(userInvitationsProvider.notifier).respond(n.id, false),
                  isPrimary: false,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: 'Accept',
                  onTap: () => ref.read(userInvitationsProvider.notifier).respond(n.id, true),
                  isPrimary: true,
                ),
              ),
            ]),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({required this.label, required this.onTap, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.teal700 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: isPrimary ? null : Border.all(color: AppColors.line),
        ),
        child: Center(
          child: Text(label, style: TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.w700, 
            color: isPrimary ? Colors.white : AppColors.ink700
          )),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 56, height: 56,
          decoration: const BoxDecoration(color: AppColors.teal50, shape: BoxShape.circle),
          child: const Icon(Icons.notifications_off_outlined, size: 28, color: AppColors.teal700),
        ),
        const SizedBox(height: 12),
        const Text('All caught up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink900)),
        const SizedBox(height: 6),
        const Text("You'll see new assignments,\nmentions and deadlines here.",
          textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.ink500)),
      ]),
    );
  }
}
