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
          ? const Center(child: Text('No recent activity'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.lineSoft),
                  ),
                  child: Row(
                    children: [
                      _getIconForType(n.type),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.message, style: GoogleFonts.inter(fontSize: 14, color: AppColors.ink900)),
                            Text('${n.createdAt.hour}:${n.createdAt.minute.toString().padLeft(2, "0")}', 
                              style: GoogleFonts.inter(fontSize: 11, color: AppColors.ink400)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _getIconForType(NotificationType type) {
    IconData icon;
    Color color;
    switch (type) {
      case NotificationType.TASK_ASSIGNED: icon = Icons.assignment_turned_in_rounded; color = Colors.blue; break;
      case NotificationType.MESSAGE_RECEIVED: icon = Icons.chat_bubble_rounded; color = AppColors.teal700; break;
      case NotificationType.PROJECT_UPDATE: icon = Icons.update_rounded; color = Colors.orange; break;
      case NotificationType.JOIN_REQUEST: icon = Icons.person_add_rounded; color = AppColors.teal700; break;
      case NotificationType.INVITATION: icon = Icons.mail_rounded; color = AppColors.teal700; break;
      default: icon = Icons.notifications_rounded; color = AppColors.ink400;
    }
    return Icon(icon, color: color, size: 20);
  }
}

class _RequestsTab extends ConsumerWidget {
  const _RequestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitationsAsync = ref.watch(userInvitationsProvider);

    return invitationsAsync.when(
      data: (invites) => RefreshIndicator(
        onRefresh: () => ref.read(userInvitationsProvider.notifier).refresh(),
        child: invites.isEmpty
          ? const Center(child: Text('No pending requests'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: invites.length,
              itemBuilder: (context, index) {
                final invite = invites[index];
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
                      Text(invite.type == InvitationType.PROJECT_INVITATION ? 'Project Invitation' : 'Join Request',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.teal700)),
                      const SizedBox(height: 4),
                      Text(invite.type == InvitationType.PROJECT_INVITATION 
                        ? '${invite.senderName} invited you to join ${invite.projectName}'
                        : '${invite.senderName} wants to join ${invite.projectName}',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink900)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => ref.read(userInvitationsProvider.notifier).respond(invite.id, false),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.ink300),
                                foregroundColor: AppColors.ink700,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Reject'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => ref.read(userInvitationsProvider.notifier).respond(invite.id, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.teal700,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Accept'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
