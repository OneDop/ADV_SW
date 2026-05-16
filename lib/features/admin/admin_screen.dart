import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

// ── Mock data models ──────────────────────────────────────────────────────────

class _AdminUser {
  final int id;
  final String name;
  final String email;
  final String role;
  bool isBlocked;
  _AdminUser({required this.id, required this.name, required this.email, required this.role, this.isBlocked = false});
}

class _AdminProject {
  final int id;
  final String name;
  final String owner;
  final String status;
  final int memberCount;
  bool isHidden;
  _AdminProject({required this.id, required this.name, required this.owner, required this.status, required this.memberCount, this.isHidden = false});
}

class _AdminSkill {
  final int id;
  String name;
  _AdminSkill({required this.id, required this.name});
}

// ── Mock state providers ──────────────────────────────────────────────────────

final _adminUsersProvider = StateProvider<List<_AdminUser>>((ref) => [
  _AdminUser(id: 1, name: 'Alex Rivera', email: 'alex@example.com', role: 'USER'),
  _AdminUser(id: 2, name: 'Sara Chen', email: 'sara@example.com', role: 'USER'),
  _AdminUser(id: 3, name: 'Rami Nasser', email: 'rami@example.com', role: 'ADMIN'),
  _AdminUser(id: 4, name: 'Lena Müller', email: 'lena@example.com', role: 'USER'),
  _AdminUser(id: 5, name: 'Jake Kim', email: 'jake@example.com', role: 'USER', isBlocked: true),
]);

final _adminProjectsProvider = StateProvider<List<_AdminProject>>((ref) => [
  _AdminProject(id: 1, name: 'SkillSync App', owner: 'Alex Rivera', status: 'IN_PROGRESS', memberCount: 4),
  _AdminProject(id: 2, name: 'Portfolio Builder', owner: 'Sara Chen', status: 'OPEN', memberCount: 2),
  _AdminProject(id: 3, name: 'Chat Module', owner: 'Rami Nasser', status: 'COMPLETED', memberCount: 3),
  _AdminProject(id: 4, name: 'Legacy Dashboard', owner: 'Jake Kim', status: 'CANCELLED', memberCount: 1, isHidden: true),
]);

final _adminSkillsProvider = StateProvider<List<_AdminSkill>>((ref) => [
  _AdminSkill(id: 1, name: 'Flutter'),
  _AdminSkill(id: 2, name: 'Spring Boot'),
  _AdminSkill(id: 3, name: 'React'),
  _AdminSkill(id: 4, name: 'Figma'),
  _AdminSkill(id: 5, name: 'PostgreSQL'),
  _AdminSkill(id: 6, name: 'TypeScript'),
  _AdminSkill(id: 7, name: 'Kotlin'),
  _AdminSkill(id: 8, name: 'UX Design'),
]);

// ── Main Screen ───────────────────────────────────────────────────────────────

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink900),
            onPressed: () => context.pop(),
          ),
          title: const Text('Admin Panel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink900)),
          bottom: const TabBar(
            labelColor: AppColors.teal700,
            unselectedLabelColor: AppColors.ink400,
            indicatorColor: AppColors.teal700,
            labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            tabs: [
              Tab(icon: Icon(Icons.dashboard_rounded, size: 18), text: 'Dashboard'),
              Tab(icon: Icon(Icons.people_rounded, size: 18), text: 'Users'),
              Tab(icon: Icon(Icons.folder_rounded, size: 18), text: 'Projects'),
              Tab(icon: Icon(Icons.psychology_rounded, size: 18), text: 'Skills'),
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
    final users = ref.watch(_adminUsersProvider);
    final projects = ref.watch(_adminProjectsProvider);
    final skills = ref.watch(_adminSkillsProvider);

    final totalUsers = users.length;
    final activeUsers = users.where((u) => !u.isBlocked).length;
    final blockedUsers = users.where((u) => u.isBlocked).length;
    final projectOwners = users.where((u) => u.role == 'USER').length;
    final activeProjects = projects.where((p) => p.status == 'IN_PROGRESS' || p.status == 'OPEN').length;
    final endedProjects = projects.where((p) => p.status == 'COMPLETED' || p.status == 'CANCELLED').length;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _SectionLabel('Overview'),
        const SizedBox(height: 10),
        Row(children: [
          _StatTile(label: 'Total Users', value: '$totalUsers', icon: Icons.people_rounded, color: AppColors.teal700),
          const SizedBox(width: 10),
          _StatTile(label: 'Active Users', value: '$activeUsers', icon: Icons.check_circle_rounded, color: AppColors.success700),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _StatTile(label: 'Blocked Users', value: '$blockedUsers', icon: Icons.block_rounded, color: const Color(0xFFDC2626)),
          const SizedBox(width: 10),
          _StatTile(label: 'Project Owners', value: '$projectOwners', icon: Icons.admin_panel_settings_rounded, color: AppColors.warm700),
        ]),
        const SizedBox(height: 20),
        _SectionLabel('Projects'),
        const SizedBox(height: 10),
        Row(children: [
          _StatTile(label: 'Total Projects', value: '${projects.length}', icon: Icons.folder_rounded, color: AppColors.teal700),
          const SizedBox(width: 10),
          _StatTile(label: 'Active Projects', value: '$activeProjects', icon: Icons.rocket_launch_rounded, color: AppColors.success700),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _StatTile(label: 'Ended Projects', value: '$endedProjects', icon: Icons.archive_rounded, color: AppColors.ink500),
          const SizedBox(width: 10),
          _StatTile(label: 'Skills Available', value: '${skills.length}', icon: Icons.psychology_rounded, color: const Color(0xFF7C3AED)),
        ]),
      ],
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
    final users = ref.watch(_adminUsersProvider);
    final filtered = _query.isEmpty
        ? users
        : users.where((u) => u.name.toLowerCase().contains(_query.toLowerCase()) || u.email.toLowerCase().contains(_query.toLowerCase())).toList();

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: _SearchField(hint: 'Search users...', onChanged: (v) => setState(() => _query = v)),
      ),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (_, i) => _UserTile(user: filtered[i]),
        ),
      ),
    ]);
  }
}

class _UserTile extends ConsumerWidget {
  final _AdminUser user;
  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: user.isBlocked ? const Color(0xFFFEE2E2) : AppColors.teal50,
          child: Text(user.name[0],
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: user.isBlocked ? const Color(0xFFDC2626) : AppColors.teal700,
            )),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(user.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink900)),
            if (user.isBlocked) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(999)),
                child: const Text('BLOCKED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFFDC2626))),
              ),
            ],
          ]),
          Text(user.email, style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
        ])),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.ink500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          onSelected: (action) {
            final notifier = ref.read(_adminUsersProvider.notifier);
            final users = List<_AdminUser>.from(notifier.state);
            final idx = users.indexWhere((u) => u.id == user.id);
            if (idx == -1) return;
            if (action == 'block') {
              users[idx].isBlocked = true;
            } else if (action == 'unblock') {
              users[idx].isBlocked = false;
            } else if (action == 'promote') {
              users[idx] = _AdminUser(
                id: users[idx].id, name: users[idx].name,
                email: users[idx].email, role: 'ADMIN',
                isBlocked: users[idx].isBlocked,
              );
            } else if (action == 'demote') {
              users[idx] = _AdminUser(
                id: users[idx].id, name: users[idx].name,
                email: users[idx].email, role: 'USER',
                isBlocked: users[idx].isBlocked,
              );
            }
            notifier.state = users;
          },
          itemBuilder: (_) => [
            if (!user.isBlocked)
              const PopupMenuItem(value: 'block', child: Row(children: [
                Icon(Icons.block_rounded, size: 16, color: Color(0xFFDC2626)),
                SizedBox(width: 10),
                Text('Block user', style: TextStyle(color: Color(0xFFDC2626))),
              ]))
            else
              const PopupMenuItem(value: 'unblock', child: Row(children: [
                Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.success700),
                SizedBox(width: 10),
                Text('Unblock user', style: TextStyle(color: AppColors.success700)),
              ])),
            if (user.role != 'ADMIN')
              const PopupMenuItem(value: 'promote', child: Row(children: [
                Icon(Icons.admin_panel_settings_rounded, size: 16, color: AppColors.teal700),
                SizedBox(width: 10),
                Text('Promote to Admin'),
              ]))
            else
              const PopupMenuItem(value: 'demote', child: Row(children: [
                Icon(Icons.person_rounded, size: 16, color: AppColors.ink700),
                SizedBox(width: 10),
                Text('Remove Admin role'),
              ])),
          ],
        ),
      ]),
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
    final projects = ref.watch(_adminProjectsProvider);
    final filtered = _query.isEmpty
        ? projects
        : projects.where((p) => p.name.toLowerCase().contains(_query.toLowerCase())).toList();

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: _SearchField(hint: 'Search projects...', onChanged: (v) => setState(() => _query = v)),
      ),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (_, i) => _ProjectTile(project: filtered[i]),
        ),
      ),
    ]);
  }
}

class _ProjectTile extends ConsumerWidget {
  final _AdminProject project;
  const _ProjectTile({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(project.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: project.isHidden ? AppColors.bgAlt : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: project.isHidden ? AppColors.line : AppColors.lineSoft),
        boxShadow: project.isHidden ? [] : AppTheme.shadowSm,
      ),
      child: Row(children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(color: AppColors.teal50, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.folder_rounded, color: AppColors.teal700, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Flexible(child: Text(project.name,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                color: project.isHidden ? AppColors.ink400 : AppColors.ink900))),
            if (project.isHidden) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.bgAlt, borderRadius: BorderRadius.circular(999), border: Border.all(color: AppColors.line)),
                child: const Text('HIDDEN', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.ink500)),
              ),
            ],
          ]),
          const SizedBox(height: 3),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
              child: Text(project.status, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: statusColor)),
            ),
            const SizedBox(width: 8),
            Text('${project.memberCount} members · ${project.owner}',
              style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
          ]),
        ])),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.ink500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          onSelected: (action) {
            final notifier = ref.read(_adminProjectsProvider.notifier);
            final projects = List<_AdminProject>.from(notifier.state);
            final idx = projects.indexWhere((p) => p.id == project.id);
            if (idx == -1) return;
            if (action == 'hide') {
              projects[idx].isHidden = true;
            } else if (action == 'show') {
              projects[idx].isHidden = false;
            }
            notifier.state = projects;
          },
          itemBuilder: (_) => [
            if (!project.isHidden)
              const PopupMenuItem(value: 'hide', child: Row(children: [
                Icon(Icons.visibility_off_rounded, size: 16, color: AppColors.ink700),
                SizedBox(width: 10),
                Text('Hide from users'),
              ]))
            else
              const PopupMenuItem(value: 'show', child: Row(children: [
                Icon(Icons.visibility_rounded, size: 16, color: AppColors.teal700),
                SizedBox(width: 10),
                Text('Show to users'),
              ])),
          ],
        ),
      ]),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'IN_PROGRESS': return AppColors.warm700;
      case 'OPEN': return AppColors.teal700;
      case 'COMPLETED': return AppColors.success700;
      default: return AppColors.ink400;
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

  void _addSkill() {
    final name = _ctrl.text.trim();
    if (name.isEmpty) return;
    final notifier = ref.read(_adminSkillsProvider.notifier);
    final skills = List<_AdminSkill>.from(notifier.state);
    final newId = skills.isEmpty ? 1 : skills.map((s) => s.id).reduce((a, b) => a > b ? a : b) + 1;
    notifier.state = [...skills, _AdminSkill(id: newId, name: name)];
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final skills = ref.watch(_adminSkillsProvider);

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: AnimatedPadding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          duration: const Duration(milliseconds: 200),
          child: Row(children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line), boxShadow: AppTheme.shadowSm,
              ),
              child: TextField(
                controller: _ctrl,
                onSubmitted: (_) => _addSkill(),
                style: const TextStyle(fontSize: 14, color: AppColors.ink900),
                decoration: const InputDecoration(
                  hintText: 'New skill name...',
                  hintStyle: TextStyle(color: AppColors.ink400, fontSize: 14),
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
              height: 48, width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: AppTheme.primaryGradient,
                boxShadow: [BoxShadow(color: AppColors.teal700.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
            ),
          ),
          ]),
        ),
      ),
      const SizedBox(height: 12),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: skills.length,
          itemBuilder: (_, i) {
            final skill = skills[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.lineSoft), boxShadow: AppTheme.shadowSm,
              ),
              child: Row(children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: AppColors.teal50, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.psychology_rounded, size: 16, color: AppColors.teal700),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(skill.name,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink900))),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFDC2626)),
                  onPressed: () {
                    final notifier = ref.read(_adminSkillsProvider.notifier);
                    notifier.state = notifier.state.where((s) => s.id != skill.id).toList();
                  },
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ]),
            );
          },
        ),
      ),
    ]);
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink500, letterSpacing: 0.6));
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatTile({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.lineSoft), boxShadow: AppTheme.shadowSm,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
        ]),
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
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line), boxShadow: AppTheme.shadowSm,
      ),
      child: Row(children: [
        const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Icon(Icons.search_rounded, size: 18, color: AppColors.ink400)),
        Expanded(child: TextField(
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: AppColors.ink900),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.ink400, fontSize: 14),
            border: InputBorder.none, contentPadding: EdgeInsets.zero,
          ),
        )),
      ]),
    );
  }
}
