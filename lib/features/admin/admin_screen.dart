import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/models/admin_model.dart';
import 'package:advsw/models/skill_model.dart';
import 'package:advsw/services/admin_service.dart';
import 'package:advsw/providers/skill_provider.dart';
import 'package:go_router/go_router.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final _adminServiceProvider = Provider<AdminService>((ref) => AdminService());

// Stats
class _AdminStatsNotifier extends AsyncNotifier<AdminStats> {
  @override
  FutureOr<AdminStats> build() => ref.watch(_adminServiceProvider).getStats();

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(_adminServiceProvider).getStats(),
    );
  }
}

final _adminStatsProvider =
    AsyncNotifierProvider<_AdminStatsNotifier, AdminStats>(
      _AdminStatsNotifier.new,
    );

// Users
class _AdminUsersNotifier extends AsyncNotifier<List<AdminUser>> {
  @override
  FutureOr<List<AdminUser>> build() =>
      ref.watch(_adminServiceProvider).getAllUsers();

  Future<void> toggleStatus(int id) async {
    state = await AsyncValue.guard(() async {
      final updated = await ref
          .read(_adminServiceProvider)
          .toggleUserStatus(id);
      return state.value!.map((u) => u.id == id ? updated : u).toList();
    });
    ref.read(_adminStatsProvider.notifier).refresh();
  }

  Future<void> promote(int id) async {
    state = await AsyncValue.guard(() async {
      final updated = await ref.read(_adminServiceProvider).promoteUser(id);
      return state.value!.map((u) => u.id == id ? updated : u).toList();
    });
    ref.read(_adminStatsProvider.notifier).refresh();
  }
}

final _adminUsersProvider =
    AsyncNotifierProvider<_AdminUsersNotifier, List<AdminUser>>(
      _AdminUsersNotifier.new,
    );

// Projects
class _AdminProjectsNotifier extends AsyncNotifier<List<AdminProject>> {
  @override
  FutureOr<List<AdminProject>> build() =>
      ref.watch(_adminServiceProvider).getAllProjects();

  Future<void> toggleStatus(int id) async {
    state = await AsyncValue.guard(() async {
      final updated = await ref
          .read(_adminServiceProvider)
          .toggleProjectStatus(id);
      return state.value!.map((p) => p.id == id ? updated : p).toList();
    });
    ref.read(_adminStatsProvider.notifier).refresh();
  }
}

final _adminProjectsProvider =
    AsyncNotifierProvider<_AdminProjectsNotifier, List<AdminProject>>(
      _AdminProjectsNotifier.new,
    );

// ── Main Screen ───────────────────────────────────────────────────────────────

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Admin Panel',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          bottom: const TabBar(
            labelColor: AppColors.teal700,
            unselectedLabelColor: AppColors.ink400,
            indicatorColor: AppColors.teal700,
            labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            tabs: [
              Tab(
                icon: Icon(Icons.dashboard_rounded, size: 18),
                text: 'Dashboard',
              ),
              Tab(icon: Icon(Icons.people_rounded, size: 18), text: 'Users'),
              Tab(icon: Icon(Icons.folder_rounded, size: 18), text: 'Projects'),
              Tab(
                icon: Icon(Icons.psychology_rounded, size: 18),
                text: 'Skills',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _DashboardTab(),
            _UsersTab(),
            _ProjectsTab(),
            _SkillsTab(),
          ],
        ),
      ),
    );
  }
}

// ── FR43: Dashboard Tab ───────────────────────────────────────────────────────

class _DashboardTab extends ConsumerWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(_adminStatsProvider);

    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (s) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionLabel('Overview'),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatTile(
                label: 'Total Users',
                value: '${s.totalUsers}',
                icon: Icons.people_rounded,
                color: AppColors.teal700,
              ),
              const SizedBox(width: 10),
              _StatTile(
                label: 'Active Users',
                value: '${s.activeUsers}',
                icon: Icons.check_circle_rounded,
                color: AppColors.success700,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatTile(
                label: 'Blocked Users',
                value: '${s.blockedUsers}',
                icon: Icons.block_rounded,
                color: const Color(0xFFDC2626),
              ),
              const SizedBox(width: 10),
              _StatTile(
                label: 'Admin Users',
                value: '${s.adminUsers}',
                icon: Icons.admin_panel_settings_rounded,
                color: AppColors.warm700,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionLabel('Projects'),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatTile(
                label: 'Total Projects',
                value: '${s.totalProjects}',
                icon: Icons.folder_rounded,
                color: AppColors.teal700,
              ),
              const SizedBox(width: 10),
              _StatTile(
                label: 'Active Projects',
                value: '${s.activeProjects}',
                icon: Icons.rocket_launch_rounded,
                color: AppColors.success700,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatTile(
                label: 'Ended Projects',
                value: '${s.endedProjects}',
                icon: Icons.archive_rounded,
                color: AppColors.ink500,
              ),
              const SizedBox(width: 10),
              _StatTile(
                label: 'Skills Available',
                value: '${s.totalSkills}',
                icon: Icons.psychology_rounded,
                color: const Color(0xFF7C3AED),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── FR44 + FR42: Users Tab ────────────────────────────────────────────────────

class _UsersTab extends ConsumerStatefulWidget {
  const _UsersTab();

  @override
  ConsumerState<_UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends ConsumerState<_UsersTab> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(_adminUsersProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: _SearchField(
            hint: 'Search users...',
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: usersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (users) {
              final filtered = _query.isEmpty
                  ? users
                  : users
                        .where(
                          (u) =>
                              u.name.toLowerCase().contains(
                                _query.toLowerCase(),
                              ) ||
                              u.email.toLowerCase().contains(
                                _query.toLowerCase(),
                              ),
                        )
                        .toList();
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (_, i) => _UserTile(user: filtered[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _UserTile extends ConsumerWidget {
  final AdminUser user;
  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: user.isBlocked
                ? const Color(0xFFFEE2E2)
                : AppColors.teal50,
            child: Text(
              user.name.isNotEmpty ? user.name[0] : '?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: user.isBlocked
                    ? const Color(0xFFDC2626)
                    : AppColors.teal700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (user.role == 'ADMIN') ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.teal50,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'ADMIN',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.teal700,
                          ),
                        ),
                      ),
                    ],
                    if (user.isBlocked) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'BLOCKED',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  user.email,
                  style: const TextStyle(fontSize: 11, color: AppColors.ink500),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              size: 18,
              color: AppColors.ink500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onSelected: (action) async {
              try {
                if (action == 'toggle_block') {
                  await ref
                      .read(_adminUsersProvider.notifier)
                      .toggleStatus(user.id);
                } else if (action == 'promote') {
                  await ref.read(_adminUsersProvider.notifier).promote(user.id);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: const Color(0xFFDC2626),
                    ),
                  );
                }
              }
            },
            itemBuilder: (_) => [
              if (user.role != 'ADMIN') ...[
                PopupMenuItem(
                  value: 'toggle_block',
                  child: Row(
                    children: [
                      Icon(
                        user.isBlocked
                            ? Icons.check_circle_outline_rounded
                            : Icons.block_rounded,
                        size: 16,
                        color: user.isBlocked
                            ? AppColors.success700
                            : const Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        user.isBlocked ? 'Unblock user' : 'Block user',
                        style: TextStyle(
                          color: user.isBlocked
                              ? AppColors.success700
                              : const Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'promote',
                  child: Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 16,
                        color: AppColors.teal700,
                      ),
                      SizedBox(width: 10),
                      Text('Promote to Admin'),
                    ],
                  ),
                ),
              ] else
                const PopupMenuItem(
                  enabled: false,
                  child: Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 16,
                        color: AppColors.ink400,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'System Admin',
                        style: TextStyle(color: AppColors.ink400),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── FR45: Projects Tab ────────────────────────────────────────────────────────

class _ProjectsTab extends ConsumerStatefulWidget {
  const _ProjectsTab();

  @override
  ConsumerState<_ProjectsTab> createState() => _ProjectsTabState();
}

class _ProjectsTabState extends ConsumerState<_ProjectsTab> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(_adminProjectsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: _SearchField(
            hint: 'Search projects...',
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: projectsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (projects) {
              final filtered = _query.isEmpty
                  ? projects
                  : projects
                        .where(
                          (p) => p.name.toLowerCase().contains(
                            _query.toLowerCase(),
                          ),
                        )
                        .toList();
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (_, i) => _ProjectTile(project: filtered[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProjectTile extends ConsumerWidget {
  final AdminProject project;
  const _ProjectTile({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(project.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: project.isHidden
            ? AppColors.bgAlt
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: project.isHidden ? AppColors.line : AppColors.lineSoft,
        ),
        boxShadow: project.isHidden ? [] : AppTheme.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.teal50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.folder_rounded,
              color: AppColors.teal700,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        project.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: project.isHidden
                              ? AppColors.ink400
                              : AppColors.ink900,
                        ),
                      ),
                    ),
                    if (project.isHidden) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgAlt,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: const Text(
                          'HIDDEN',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        project.status,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Wrap this in Expanded to stop horizontal overflow
                    Expanded(
                      child: Text(
                        '${project.memberCount} members · ${project.ownerName}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.ink500,
                        ),
                        overflow: TextOverflow
                            .ellipsis, // Adds '...' if text is too long
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              size: 18,
              color: AppColors.ink500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onSelected: (action) async {
              try {
                if (action == 'toggle') {
                  await ref
                      .read(_adminProjectsProvider.notifier)
                      .toggleStatus(project.id);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: const Color(0xFFDC2626),
                    ),
                  );
                }
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                      project.isHidden
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      size: 16,
                      color: project.isHidden
                          ? AppColors.teal700
                          : AppColors.ink700,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      project.isHidden ? 'Show to users' : 'Hide from users',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'IN_PROGRESS':
        return AppColors.warm700;
      case 'OPEN':
        return AppColors.teal700;
      case 'COMPLETED':
        return AppColors.success700;
      default:
        return AppColors.ink400;
    }
  }
}

// ── FR46: Skills Tab ──────────────────────────────────────────────────────────

class _SkillsTab extends ConsumerStatefulWidget {
  const _SkillsTab();

  @override
  ConsumerState<_SkillsTab> createState() => _SkillsTabState();
}

class _SkillsTabState extends ConsumerState<_SkillsTab> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _addSkill() async {
    final name = _ctrl.text.trim();
    if (name.isEmpty) return;
    try {
      await ref
          .read(allSkillsProvider.notifier)
          .createSkill(CreateSkillRequest(name: name));
      _ctrl.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final skillsAsync = ref.watch(allSkillsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: AnimatedPadding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            duration: const Duration(milliseconds: 200),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.line),
                      boxShadow: AppTheme.shadowSm,
                    ),
                    child: TextField(
                      controller: _ctrl,
                      onSubmitted: (_) => _addSkill(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.ink900,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'New skill name...',
                        hintStyle: TextStyle(
                          color: AppColors.ink400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _addSkill,
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: AppTheme.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.teal700.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: skillsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (skills) => ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: skills.length,
              itemBuilder: (_, i) {
                final skill = skills[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.lineSoft),
                    boxShadow: AppTheme.shadowSm,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.teal50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.psychology_rounded,
                          size: 16,
                          color: AppColors.teal700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          skill.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink900,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: Color(0xFFDC2626),
                        ),
                        onPressed: () async {
                          try {
                            await ref
                                .read(allSkillsProvider.notifier)
                                .deleteSkill(skill.id);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: const Color(0xFFDC2626),
                                ),
                              );
                            }
                          }
                        },
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.ink500,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.lineSoft),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.ink500),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchField({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.search_rounded,
              size: 18,
              color: AppColors.ink400,
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(fontSize: 14, color: AppColors.ink900),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: AppColors.ink400,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
