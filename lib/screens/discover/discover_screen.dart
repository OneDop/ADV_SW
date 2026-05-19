import 'package:advsw/models/search_model.dart';
import 'package:advsw/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/screens/home/widgets.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  String _tab = 'people';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final userSearchAsync = ref.watch(userSearchProvider);
    final projectSearchAsync = ref.watch(projectSearchProvider);

    return Scaffold(
      body: SafeArea(
        child: AnimatedPadding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          duration: const Duration(milliseconds: 200),
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
                child: _SearchBar(
                  value: _query, 
                  onChanged: (v) {
                    setState(() => _query = v);
                    if (_tab == 'people') {
                      ref.read(userSearchProvider.notifier).search(name: v);
                    } else {
                      ref.read(projectSearchProvider.notifier).searchProjects(name: v);
                    }
                  }
                ),
              ),

              // Tab toggle
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: _SegmentedToggle(
                  value: _tab,
                  options: const [('people', 'People'), ('projects', 'Projects')],
                  onChange: (v) {
                    setState(() => _tab = v);
                    if (v == 'people') {
                      ref.read(userSearchProvider.notifier).search(name: _query);
                    } else {
                      ref.read(projectSearchProvider.notifier).searchProjects(name: _query);
                    }
                  },
                ),
              ),

              // Content
              Expanded(
              child: _tab == 'people' 
                ? userSearchAsync.when(
                    data: (users) => users.isEmpty 
                      ? const Center(child: Text('No users found'))
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
                          itemCount: users.length,
                          itemBuilder: (_, i) => _UserCard(user: users[i]),
                        ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(child: Text('Error: $err')),
                  )
                : projectSearchAsync.when(
                    data: (projects) => projects.isEmpty
                      ? const Center(child: Text('No projects found'))
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
                          itemCount: projects.length,
                          itemBuilder: (_, i) => _ProjectDiscoverCard(project: projects[i]),
                        ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(child: Text('Error: $err')),
                  ),
            ),
          ],
        ),
        ),
      ),
    );
  }
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

class _UserCard extends StatelessWidget {
  final SearchUserResult user;
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
            UserAvatar(name: '${user.firstName} ${user.lastName}', size: 44, status: 'online', imageUrl: user.profilePictureUrl),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${user.firstName} ${user.lastName}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.ink900)),
                Text(user.email, style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
              ],
            )),
            _InviteBtn(onTap: () {}),
          ]),
          const SizedBox(height: 12),
          Wrap(spacing: 5, runSpacing: 6,
            children: user.skills.map((s) => _SkillTag(s.skillName)).toList()),
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
  final SearchProjectResult project;
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
            Text(project.description, style: const TextStyle(fontSize: 12, color: AppColors.ink500)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal50, borderRadius: BorderRadius.circular(999), border: Border.all(color: AppColors.teal100)),
              child: Text(project.status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.teal700)),
            ),
          ],
        )),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Text('Open project', style: TextStyle(fontSize: 10, color: AppColors.ink500)),
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
