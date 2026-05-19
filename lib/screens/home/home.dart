import 'package:advsw/models/user_model.dart';
import 'package:advsw/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/providers/user_provider.dart';
import 'package:advsw/providers/project_provider.dart';
import 'package:intl/intl.dart';
import 'widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final myProjectsAsync = ref.watch(myProjectsProvider);

    return Scaffold(
      body: SafeArea(
        child: userProfileAsync.when(
          data: (user) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Row(
                    children: [
                      UserAvatar(
                        name: '${user.firstName} ${user.lastName}',
                        size: 42,
                        status: user.availabilityStatus.name,
                        imageUrl: user.profilePictureUrl,
                        ring: 2,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hi ${user.firstName}',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.4)),
                            Text(DateFormat('EEEE, MMM dd').format(DateTime.now()), 
                              style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
                          ],
                        ),
                      ),
                      _IconBtn(icon: Icons.search_rounded, onTap: () {
                        StatefulNavigationShell.of(context).goBranch(2); // Branch 2: Global Search
                      }),
                      const SizedBox(width: 8),
                      _IconBtn(icon: Icons.notifications_none_rounded, onTap: () {
                        StatefulNavigationShell.of(context).goBranch(4); // Branch 4: Inbox/Notifications
                      }, badge: 3),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 8),
                    _HeroCard(onAction: () => StatefulNavigationShell.of(context).goBranch(1)), // Go to Discover

                    SectionHeader(
                      title: 'My Projects',
                      action: 'View all',
                      onAction: () => context.push('/my-projects'),
                    ),
                    SizedBox(
                      height: 196,
                      child: myProjectsAsync.when(
                        data: (projects) => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemCount: projects.length + 1,
                          itemBuilder: (_, i) {
                            if (i == projects.length) return _NewProjectBtn(onTap: () => _showCreateProjectSheet(context, ref));
                            return ProjectCard(
                              project: projects[i],
                              onTap: () => context.push('/project/${projects[i].id}'),
                            );
                          },
                        ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(child: Text('Error: $err')),
                      ),
                    ),

                    const SizedBox(height: 24),
                    _RatingCard(user: user),
                  ]),
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final VoidCallback onAction;
  const _HeroCard({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: AppTheme.primaryGradient,
        boxShadow: [BoxShadow(color: AppColors.teal700.withValues(alpha: 0.25), blurRadius: 24, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PROJECT DISCOVERY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: Colors.white70)),
          const SizedBox(height: 6),
          const Text('Find new projects to\ncollaborate on.',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, height: 1.15, letterSpacing: -0.3)),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white38)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Text('Browse Projects', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                SizedBox(width: 6),
                Icon(Icons.explore_outlined, size: 14, color: Colors.white),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  final UserProfileResponse user;
  const _RatingCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final int? badge;
  const _IconBtn({required this.icon, this.onTap, this.badge});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line), boxShadow: AppTheme.shadowSm,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 20, color: AppColors.ink900),
            if (badge != null && badge! > 0)
              Positioned(top: 6, right: 6, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFE14B4B), shape: BoxShape.circle))),
          ],
        ),
      ),
    );
  }
}

class _NewProjectBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _NewProjectBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.ink300, width: 1.5, style: BorderStyle.solid),
        ),
        child: const Center(child: Icon(Icons.add_rounded, size: 32, color: AppColors.teal700)),
      ),
    );
  }
}

void _showCreateProjectSheet(BuildContext context, WidgetRef ref) {
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + MediaQuery.of(ctx).padding.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'New Project',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink900),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: const Icon(Icons.close_rounded, color: AppColors.ink500),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _SheetLabel('NAME'),
            const SizedBox(height: 6),
            _SheetInput(hint: 'e.g. Mobile App Redesign', controller: nameCtrl),
            const SizedBox(height: 14),
            _SheetLabel('DESCRIPTION'),
            const SizedBox(height: 6),
            _SheetInput(hint: 'What is this project about?', controller: descCtrl, maxLines: 3),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  if (name.isEmpty) return;
                  Navigator.pop(ctx);
                  ref.read(myProjectsProvider.notifier).createProject(
                    CreateProjectRequest(name: name, description: descCtrl.text.trim()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Create Project', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SheetLabel extends StatelessWidget {
  final String text;
  const _SheetLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppColors.ink500),
  );
}

class _SheetInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  const _SheetInput({required this.hint, required this.controller, this.maxLines = 1});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.bgAlt,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.line),
    ),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: AppColors.ink900),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.ink400, fontSize: 14),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    ),
  );
}
