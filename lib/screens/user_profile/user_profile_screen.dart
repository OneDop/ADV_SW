import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/data/seed_data.dart';
import 'package:advsw/screens/home/widgets.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  DiscoverUser? _findUser() {
    try {
      return SeedData.discoverUsers.firstWhere((u) => u.id == userId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _findUser();

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line), boxShadow: AppTheme.shadowSm,
                      ),
                      child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.ink900),
                    ),
                  ),
                ]),
              ),
              const Expanded(
                child: Center(
                  child: Text('User not found', style: TextStyle(fontSize: 16, color: AppColors.ink500)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final statusColor = user.status == 'available'
        ? const Color(0xFF3BB273)
        : user.status == 'busy'
            ? AppColors.warm600
            : AppColors.ink400;

    final statusLabel = user.status[0].toUpperCase() + user.status.substring(1);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.line), boxShadow: AppTheme.shadowSm,
                        ),
                        child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.ink900),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text('Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.3)),
                    ),
                    GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Message sent to ${user.name}'),
                          backgroundColor: AppColors.teal700,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.line), boxShadow: AppTheme.shadowSm,
                        ),
                        child: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColors.ink700),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Hero card
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        colors: [AppColors.teal700, AppColors.teal600],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(children: [
                      Positioned(right: -60, top: -60,
                        child: Container(width: 200, height: 200, decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [AppColors.aqua.withValues(alpha: 0.3), Colors.transparent]),
                        ))),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          UserAvatar(name: user.name, size: 64, status: user.status, ring: 3),
                          const SizedBox(width: 16),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.3)),
                            const SizedBox(height: 2),
                            Text(user.role, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(999)),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                CircleAvatar(backgroundColor: statusColor, radius: 3),
                                const SizedBox(width: 6),
                                Text(statusLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                              ]),
                            ),
                          ])),
                        ]),
                        if (user.bio.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Text(user.bio, style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.5)),
                        ],
                        const SizedBox(height: 16),
                        Row(children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Invitation sent to ${user.name}'),
                                  backgroundColor: AppColors.teal700,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.95),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Icon(Icons.person_add_alt_1_rounded, size: 15, color: AppColors.teal700),
                                  SizedBox(width: 6),
                                  Text('Invite to project', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.teal700)),
                                ]),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Message sent to ${user.name}'),
                                backgroundColor: AppColors.teal700,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white38),
                              ),
                              child: const Row(children: [
                                Icon(Icons.chat_bubble_outline_rounded, size: 14, color: Colors.white),
                                SizedBox(width: 6),
                                Text('Message', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                              ]),
                            ),
                          ),
                        ]),
                      ]),
                    ]),
                  ),

                  // Skills
                  const SectionHeader(title: 'Skills'),
                  Wrap(
                    spacing: 6, runSpacing: 8,
                    children: user.skills.map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.teal50,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.teal100),
                      ),
                      child: Text(s, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.teal700)),
                    )).toList(),
                  ),

                  // About
                  if (user.bio.isNotEmpty) ...[
                    const SectionHeader(title: 'About'),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.lineSoft),
                        boxShadow: AppTheme.shadowSm,
                      ),
                      child: Text(user.bio, style: const TextStyle(fontSize: 13, color: AppColors.ink700, height: 1.6)),
                    ),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
