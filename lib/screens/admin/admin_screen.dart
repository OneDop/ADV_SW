import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/data/seed_data.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  late List<AdminUserEntry> _users;
  late List<AdminSkillEntry> _skills;
  late List<AdminProjectEntry> _projects;
  final _skillCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tab      = TabController(length: 4, vsync: this);
    _users    = List.from(SeedAdmin.users);
    _skills   = List.from(SeedAdmin.skills);
    _projects = List.from(SeedAdmin.projects);
  }

  @override
  void dispose() {
    _tab.dispose();
    _skillCtrl.dispose();
    super.dispose();
  }

  void _toggleBlock(AdminUserEntry u) => setState(() => u.isBlocked = !u.isBlocked);
  void _toggleAdmin(AdminUserEntry u) => setState(() => u.isAdmin = !u.isAdmin);
  void _toggleHide(AdminProjectEntry p) => setState(() => p.isHidden = !p.isHidden);

  void _addSkill() {
    final name = _skillCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _skills.add(AdminSkillEntry(
        id: 's${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        userCount: 0,
      ));
    });
    _skillCtrl.clear();
  }

  void _deleteSkill(AdminSkillEntry s) => setState(() => _skills.remove(s));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgAlt,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line),
                        boxShadow: AppTheme.shadowSm,
                      ),
                      child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.ink900),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admin Panel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.3)),
                        Text('System administration', style: TextStyle(fontSize: 11, color: AppColors.ink500)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1E6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.warm300),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield_outlined, size: 13, color: AppColors.warm600),
                        SizedBox(width: 4),
                        Text('Admin', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.warm600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: TabBar(
                controller: _tab,
                labelColor: AppColors.teal700,
                unselectedLabelColor: AppColors.ink500,
                labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                indicatorColor: AppColors.teal700,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: AppColors.lineSoft,
                tabs: const [
                  Tab(text: 'Dashboard'),
                  Tab(text: 'Users'),
                  Tab(text: 'Projects'),
                  Tab(text: 'Skills'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _DashboardTab(),
                  _UsersTab(users: _users, onBlock: _toggleBlock, onToggleAdmin: _toggleAdmin),
                  _ProjectsTab(projects: _projects, onToggleHide: _toggleHide),
                  _SkillsTab(skills: _skills, ctrl: _skillCtrl, onAdd: _addSkill, onDelete: _deleteSkill),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dashboard tab ──────────────────────────────────────────────────────────────

class _DashboardTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = SeedAdmin.stats;
    final cards = [
      (Icons.people_rounded,              'Total Users',      '${s.totalUsers}',       AppColors.teal50,     AppColors.teal700),
      (Icons.folder_rounded,              'Project Owners',   '${s.projectOwners}',    const Color(0xFFE8F4FA), const Color(0xFF0E5B85)),
      (Icons.check_circle_outline_rounded,'Active Users',     '${s.activeUsers}',      AppColors.success100, AppColors.success700),
      (Icons.block_rounded,               'Blocked Users',    '${s.blockedUsers}',     AppColors.warm100,    AppColors.warm600),
      (Icons.rocket_launch_outlined,      'Active Projects',  '${s.activeProjects}',   AppColors.teal50,     AppColors.teal700),
      (Icons.flag_outlined,               'Ended Projects',   '${s.endedProjects}',    const Color(0xFFF1ECFB), const Color(0xFF5A399E)),
      (Icons.psychology_rounded,          'Skills Available', '${s.availableSkills}',  AppColors.success100, AppColors.success700),
      (Icons.storage_rounded,             'Total Projects',   '${s.totalProjects}',    AppColors.warm100,    AppColors.warm600),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      children: [
        const Text('System Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink900)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: cards.map((c) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.lineSoft),
              boxShadow: AppTheme.shadowSm,
            ),
            child: Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: c.$4, borderRadius: BorderRadius.circular(12)),
                  child: Icon(c.$1, size: 18, color: c.$5),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(c.$3, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: c.$5)),
                      Text(c.$2, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.ink500)),
                    ],
                  ),
                ),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }
}

// ── Users tab ──────────────────────────────────────────────────────────────────

class _UsersTab extends StatefulWidget {
  final List<AdminUserEntry> users;
  final ValueChanged<AdminUserEntry> onBlock;
  final ValueChanged<AdminUserEntry> onToggleAdmin;
  const _UsersTab({required this.users, required this.onBlock, required this.onToggleAdmin});

  @override
  State<_UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<_UsersTab> {
  String _filter = 'all';

  List<AdminUserEntry> get _filtered {
    if (_filter == 'blocked') return widget.users.where((u) => u.isBlocked).toList();
    if (_filter == 'admins')  return widget.users.where((u) => u.isAdmin).toList();
    return widget.users;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter chips
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            children: [
              _Chip(label: 'All', id: 'all', current: _filter, onTap: (v) => setState(() => _filter = v)),
              _Chip(label: 'Blocked', id: 'blocked', current: _filter, onTap: (v) => setState(() => _filter = v)),
              _Chip(label: 'Admins', id: 'admins', current: _filter, onTap: (v) => setState(() => _filter = v)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            itemCount: _filtered.length,
            itemBuilder: (_, i) {
              final u = _filtered[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: u.isBlocked ? const Color(0xFFF4C3C3) : AppColors.lineSoft),
                  boxShadow: AppTheme.shadowSm,
                ),
                child: Row(
                  children: [
                    _Avatar(name: u.name, blocked: u.isBlocked),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(u.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.ink900)),
                              if (u.isAdmin) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.warm100, borderRadius: BorderRadius.circular(6)),
                                  child: const Text('Admin', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.warm600)),
                                ),
                              ],
                            ],
                          ),
                          Text(u.email, style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
                        ],
                      ),
                    ),
                    // Block/Unblock
                    GestureDetector(
                      onTap: () => widget.onBlock(u),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: u.isBlocked ? AppColors.success100 : AppColors.warm100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          u.isBlocked ? 'Unblock' : 'Block',
                          style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700,
                            color: u.isBlocked ? AppColors.success700 : AppColors.warm600,
                          ),
                        ),
                      ),
                    ),
                    // Promote/Demote
                    GestureDetector(
                      onTap: () => widget.onToggleAdmin(u),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: u.isAdmin ? AppColors.warm100 : AppColors.teal50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          u.isAdmin ? Icons.person_remove_outlined : Icons.admin_panel_settings_outlined,
                          size: 16,
                          color: u.isAdmin ? AppColors.warm600 : AppColors.teal700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Projects tab ───────────────────────────────────────────────────────────────

class _ProjectsTab extends StatelessWidget {
  final List<AdminProjectEntry> projects;
  final ValueChanged<AdminProjectEntry> onToggleHide;
  const _ProjectsTab({required this.projects, required this.onToggleHide});

  Color _statusColor(String s) {
    switch (s) {
      case 'In Progress': return AppColors.warm600;
      case 'Completed':   return AppColors.success700;
      default:            return AppColors.teal700;
    }
  }

  Color _statusBgColor(String s) {
    switch (s) {
      case 'In Progress': return AppColors.warm100;
      case 'Completed':   return AppColors.success100;
      default:            return AppColors.teal50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      itemCount: projects.length,
      itemBuilder: (_, i) {
        final p = projects[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: p.isHidden ? AppColors.bgAlt : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.lineSoft),
            boxShadow: AppTheme.shadowSm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(p.name,
                            style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w800,
                              color: p.isHidden ? AppColors.ink400 : AppColors.ink900,
                              decoration: p.isHidden ? TextDecoration.lineThrough : null,
                            )),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _statusBgColor(p.status),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(p.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _statusColor(p.status))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('Owner: ${p.ownerName} · ${p.memberCount} members',
                      style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => onToggleHide(p),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: p.isHidden ? AppColors.teal50 : const Color(0xFFFEF3F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    p.isHidden ? 'Show' : 'Hide',
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700,
                      color: p.isHidden ? AppColors.teal700 : const Color(0xFFB91C1C),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Skills tab ─────────────────────────────────────────────────────────────────

class _SkillsTab extends StatelessWidget {
  final List<AdminSkillEntry> skills;
  final TextEditingController ctrl;
  final VoidCallback onAdd;
  final ValueChanged<AdminSkillEntry> onDelete;
  const _SkillsTab({required this.skills, required this.ctrl, required this.onAdd, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add skill row
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.line),
                    boxShadow: AppTheme.shadowSm,
                  ),
                  child: TextField(
                    controller: ctrl,
                    onSubmitted: (_) => onAdd(),
                    style: const TextStyle(fontSize: 14, color: AppColors.ink900),
                    decoration: const InputDecoration(
                      hintText: 'New skill name…',
                      hintStyle: TextStyle(color: AppColors.ink400, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: AppTheme.primaryGradient,
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            itemCount: skills.length,
            itemBuilder: (_, i) {
              final s = skills[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.lineSoft),
                  boxShadow: AppTheme.shadowSm,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(color: AppColors.teal50, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.psychology_rounded, size: 16, color: AppColors.teal700),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(s.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink900))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.bgAlt, borderRadius: BorderRadius.circular(8)),
                      child: Text('${s.userCount} users', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.ink500)),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => onDelete(s),
                      child: Container(
                        width: 30, height: 30,
                        decoration: BoxDecoration(color: const Color(0xFFFEF3F2), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFB91C1C)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Shared small widgets ───────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String name;
  final bool blocked;
  const _Avatar({required this.name, this.blocked = false});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join().toUpperCase();
    return Container(
      width: 38, height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: blocked ? const Color(0xFFFEF3F2) : AppColors.teal50,
      ),
      child: Center(
        child: Text(initials, style: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w700,
          color: blocked ? const Color(0xFFB91C1C) : AppColors.teal700,
        )),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label, id, current;
  final ValueChanged<String> onTap;
  const _Chip({required this.label, required this.id, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sel = current == id;
    return GestureDetector(
      onTap: () => onTap(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: sel ? AppColors.teal700 : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: sel ? AppColors.teal700 : AppColors.line),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: sel ? Colors.white : AppColors.ink700)),
      ),
    );
  }
}
