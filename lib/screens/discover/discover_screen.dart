import 'package:flutter/material.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/data/seed_data.dart';
import 'package:advsw/screens/home/widgets.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _tab = 'people';
  String _query = '';
  final List<String> _activeSkills = [];

  static const _allSkills = ['Flutter', 'Spring Boot', 'React', 'Figma', 'UX', 'PostgreSQL', 'TypeScript'];

  static const _discoverProjects = [
    _DiscoverProject(name: 'Open Tutor',    desc: 'AI tutoring co-op — looking for Flutter devs.', members: 4, skills: ['Flutter', 'Spring Boot']),
    _DiscoverProject(name: 'Local Greens',  desc: 'Marketplace for local farms.',                  members: 6, skills: ['React', 'UX']),
    _DiscoverProject(name: 'Field Notes',   desc: 'Note-taking app with offline-first sync.',      members: 2, skills: ['Flutter', 'TypeScript']),
  ];

  List<DiscoverUser> get _filteredUsers {
    var list = SeedData.discoverUsers;
    if (_query.isNotEmpty) list = list.where((u) => u.name.toLowerCase().contains(_query.toLowerCase())).toList();
    if (_activeSkills.isNotEmpty) list = list.where((u) => _activeSkills.any((s) => u.skills.contains(s))).toList();
    return list;
  }

  List<_DiscoverProject> get _filteredProjects {
    if (_query.isEmpty) return _discoverProjects;
    return _discoverProjects.where((p) => p.name.toLowerCase().contains(_query.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Discover', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.4)),
                  Text('People & open projects', style: TextStyle(fontSize: 11, color: AppColors.ink500)),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: _SearchBar(value: _query, onChanged: (v) => setState(() => _query = v)),
            ),

            // Tab toggle
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: _SegmentedToggle(
                value: _tab,
                options: const [('people', 'People'), ('projects', 'Projects')],
                onChange: (v) => setState(() => _tab = v),
              ),
            ),

            // Skill filters (people tab only)
            if (_tab == 'people')
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  children: _allSkills.map((s) {
                    final sel = _activeSkills.contains(s);
                    return _FilterChip(
                      label: s, selected: sel,
                      onTap: () => setState(() {
                        if (sel) { _activeSkills.remove(s); } else { _activeSkills.add(s); }
                      }),
                    );
                  }).toList(),
                ),
              ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                children: _tab == 'people'
                    ? _filteredUsers.map((u) => _UserCard(user: u)).toList()
                    : _filteredProjects.map((p) => _ProjectDiscoverCard(project: p)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data model ─────────────────────────────────────────────────────────────────
class _DiscoverProject {
  final String name, desc;
  final int members;
  final List<String> skills;
  const _DiscoverProject({required this.name, required this.desc, required this.members, required this.skills});
}

// ── Local widgets ──────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line), boxShadow: AppTheme.shadowSm,
      ),
      child: Row(children: [
        const Padding(padding: EdgeInsets.symmetric(horizontal: 14), child: Icon(Icons.search_rounded, size: 18, color: AppColors.ink400)),
        Expanded(child: TextField(
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: AppColors.ink900),
          decoration: const InputDecoration(
            hintText: 'Search people or projects', hintStyle: TextStyle(color: AppColors.ink400, fontSize: 14),
            border: InputBorder.none, contentPadding: EdgeInsets.zero,
          ),
        )),
      ]),
    );
  }
}

class _SegmentedToggle extends StatelessWidget {
  final String value;
  final List<(String, String)> options;
  final ValueChanged<String> onChange;

  const _SegmentedToggle({required this.value, required this.options, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.bgAlt, borderRadius: BorderRadius.circular(14)),
      child: Row(children: options.map((o) {
        final sel = value == o.$1;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChange(o.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: sel ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: sel ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 3)] : null,
              ),
              child: Text(o.$2, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: sel ? AppColors.ink900 : AppColors.ink500)),
            ),
          ),
        );
      }).toList()),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.teal700 : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? AppColors.teal700 : AppColors.line),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (selected) ...[const Icon(Icons.check_rounded, size: 12, color: Colors.white), const SizedBox(width: 4)],
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.ink700)),
        ]),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final DiscoverUser user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lineSoft), boxShadow: AppTheme.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            UserAvatar(name: user.name, size: 44, status: user.status),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.ink900)),
                Text(user.role, style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
              ],
            )),
            _InviteBtn(onTap: () {}),
          ]),
          const SizedBox(height: 12),
          Wrap(spacing: 5, runSpacing: 6,
            children: user.skills.map((s) => _SkillTag(s)).toList()),
        ],
      ),
    );
  }
}

class _InviteBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _InviteBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(color: AppColors.teal50, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.teal100)),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.person_add_alt_1_rounded, size: 14, color: AppColors.teal700),
          SizedBox(width: 5),
          Text('Invite', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.teal700)),
        ]),
      ),
    );
  }
}

class _SkillTag extends StatelessWidget {
  final String label;
  const _SkillTag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999), border: Border.all(color: AppColors.line)),
      child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.ink700)),
    );
  }
}

class _ProjectDiscoverCard extends StatelessWidget {
  final _DiscoverProject project;
  const _ProjectDiscoverCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lineSoft), boxShadow: AppTheme.shadowMd,
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink900)),
            const SizedBox(height: 4),
            Text(project.desc, style: const TextStyle(fontSize: 12, color: AppColors.ink500)),
            const SizedBox(height: 10),
            Wrap(spacing: 5, runSpacing: 6,
              children: project.skills.map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.teal50, borderRadius: BorderRadius.circular(999), border: Border.all(color: AppColors.teal100)),
                child: Text(s, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.teal700)),
              )).toList()),
          ],
        )),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${project.members} members', style: const TextStyle(fontSize: 10, color: AppColors.ink500)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: AppTheme.primaryGradient,
                boxShadow: [BoxShadow(color: AppColors.teal700.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: const Text('Request', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ]),
      ]),
    );
  }
}
