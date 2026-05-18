import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/providers/notification_provider.dart';
import 'package:advsw/providers/invitation_provider.dart';
import 'package:advsw/models/notification_model.dart';
import 'package:advsw/models/invitation_model.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          title: Text('Inbox', 
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.ink900)),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.done_all_rounded, color: AppColors.ink700),
              tooltip: 'Clear All Activity',
              onPressed: () => ref.read(notificationsProvider.notifier).deleteAllNotifications(),
            ),
          ],
          bottom: TabBar(
            labelColor: AppColors.teal700,
            unselectedLabelColor: AppColors.ink400,
            indicatorColor: AppColors.teal700,
            labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
            tabs: const [
              Tab(text: 'Activity'),
              Tab(text: 'Requests'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ActivityTab(),
            _RequestsTab(),
          ],
        ),
      ),
    );
  }
}

class _ActivityTab extends ConsumerWidget {
  const _ActivityTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return notificationsAsync.when(
      data: (notifications) => RefreshIndicator(
        onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
        child: notifications.isEmpty 
          ? const _EmptyState(
              icon: Icons.notifications_off_outlined,
              title: 'All caught up',
              subtitle: 'You\'ll see new assignments,\nmentions and deadlines here.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                return _ActivityItem(n: n);
              },
            ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _ActivityItem extends ConsumerWidget {
  final NotificationResponse n;
  const _ActivityItem({required this.n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tone = _getTone(n.type);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tone.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(tone.icon, color: tone.fg, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_getDisplayTitle(n.type), 
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink900)),
                const SizedBox(height: 2),
                Text(n.message, style: GoogleFonts.inter(fontSize: 12, color: AppColors.ink700, height: 1.4)),
                const SizedBox(height: 6),
                Text('${n.createdAt.day}/${n.createdAt.month} • ${n.createdAt.hour}:${n.createdAt.minute.toString().padLeft(2, "0")}', 
                  style: GoogleFonts.inter(fontSize: 10, color: AppColors.ink400)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.ink300),
            onPressed: () => ref.read(notificationsProvider.notifier).deleteNotification(n.id),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  ({Color bg, Color fg, IconData icon}) _getTone(NotificationType type) {
    switch (type) {
      case NotificationType.TASK_ASSIGNED:
        return (bg: AppColors.teal50, fg: AppColors.teal700, icon: Icons.assignment_turned_in_rounded);
      case NotificationType.NEW_MESSAGE:
        return (bg: const Color(0xFFE8F4FA), fg: const Color(0xFF0E5B85), icon: Icons.chat_bubble_rounded);
      case NotificationType.PROJECT_INVITATION:
      case NotificationType.JOIN_REQUEST:
      case NotificationType.JOIN_APPROVED:
      case NotificationType.JOIN_REJECTED:
        return (bg: const Color(0xFFF1ECFB), fg: const Color(0xFF5A399E), icon: Icons.person_add_rounded);
      case NotificationType.DEADLINE_REMINDER:
        return (bg: AppColors.warm100, fg: AppColors.warm700, icon: Icons.update_rounded);
    }
  }

  String _getDisplayTitle(NotificationType type) {
    switch (type) {
      case NotificationType.PROJECT_INVITATION: return 'Project Invitation';
      case NotificationType.JOIN_REQUEST: return 'Join Request';
      case NotificationType.JOIN_APPROVED: return 'Join Approved';
      case NotificationType.JOIN_REJECTED: return 'Join Rejected';
      case NotificationType.TASK_ASSIGNED: return 'Task Assigned';
      case NotificationType.NEW_MESSAGE: return 'New Message';
      case NotificationType.DEADLINE_REMINDER: return 'Deadline Reminder';
    }
  }
}

class _RequestsTab extends ConsumerWidget {
  const _RequestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitationsAsync = ref.watch(userInvitationsProvider);
    final joinRequestsAsync = ref.watch(ownerJoinRequestsProvider);

    if (invitationsAsync.isLoading || joinRequestsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (invitationsAsync.hasError) {
      return Center(child: Text('Error: ${invitationsAsync.error}'));
    }
    if (joinRequestsAsync.hasError) {
      return Center(child: Text('Error: ${joinRequestsAsync.error}'));
    }

    final invites = invitationsAsync.value ?? [];
    final joinRequests = joinRequestsAsync.value ?? [];
    final all = [...invites, ...joinRequests];

    Future<void> onRefresh() async {
      await Future.wait([
        ref.read(userInvitationsProvider.notifier).refresh(),
        ref.read(ownerJoinRequestsProvider.notifier).refresh(),
      ]);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: all.isEmpty
        ? const _EmptyState(
            icon: Icons.person_add_disabled_outlined,
            title: 'No pending requests',
            subtitle: 'Invitations and join requests\nwill appear here.',
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: all.length,
            itemBuilder: (context, index) {
              final invite = all[index];
              final isJoinRequest = invite.type == InvitationType.JOIN_REQUEST;
              void onRespond(bool accept) {
                if (isJoinRequest) {
                  ref.read(ownerJoinRequestsProvider.notifier).respond(invite.id, accept);
                } else {
                  ref.read(userInvitationsProvider.notifier).respond(invite.id, accept);
                }
              }
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppTheme.shadowSm,
                  border: Border.all(color: AppColors.lineSoft),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isJoinRequest ? 'Join Request' : 'Project Invitation',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.teal700)),
                    const SizedBox(height: 4),
                    Text(isJoinRequest
                      ? '${invite.senderName} wants to join ${invite.projectName}'
                      : '${invite.senderName} invited you to join ${invite.projectName}',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink900)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => onRespond(false),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.line),
                              foregroundColor: AppColors.ink700,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Reject', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => onRespond(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal700,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Accept', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(color: AppColors.teal50, shape: BoxShape.circle),
            child: Icon(icon, size: 32, color: AppColors.teal700),
          ),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink900)),
          const SizedBox(height: 8),
          Text(subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.ink500, height: 1.5)),
        ],
      ),
    );
  }
}
