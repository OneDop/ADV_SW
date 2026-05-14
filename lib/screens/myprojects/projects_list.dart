import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/data/seed_data.dart';
import 'widgets.dart';

class ProjectsListScreen extends StatefulWidget {
  const ProjectsListScreen({super.key});

  @override
  State<ProjectsListScreen> createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends State<ProjectsListScreen> {
  String _filter = 'all';
  String _query = '';

  List<AppProject> get _filtered {
    var list = SeedData.projects;
    if (_filter == 'owned')     list = list.where((p) => p.ownerId == SeedData.currentUser.id).toList();
    if (_filter == 'shared')    list = list.where((p) => p.ownerId != SeedData.currentUser.id).toList();
    if (_filter == 'completed') list = list.where((p) => p.status == 'Completed').toList();
    if (_query.isNotEmpty)      list = list.where((p) => p.name.toLowerCase().contains(_query.toLowerCase())).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final projects = _filtered;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Projects', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.4)),
                        Text('${SeedData.projects.length} total', style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
                      ],
                    ),
                  ),
                  _IconBtn(icon: Icons.filter_list_rounded, onTap: () {}),
                  const SizedBox(width: 8),
                  _FilledIconBtn(icon: Icons.add_rounded, onTap: () {}),
                ],
              ),
            ),

            // ── Search ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: _SearchBar(
                value: _query,
                onChanged: (v) => setState(() => _query = v),
              ),
            ),

            // ── Filter chips ───────────────────────────────────────────────────
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                children: [
                  _FilterChip(label: 'All',           id: 'all',       current: _filter, onTap: (v) => setState(() => _filter = v)),
                  _FilterChip(label: 'Owned',         id: 'owned',     current: _filter, onTap: (v) => setState(() => _filter = v)),
                  _FilterChip(label: 'Shared with me',id: 'shared',    current: _filter, onTap: (v) => setState(() => _filter = v)),
                  _FilterChip(label: 'Completed',     id: 'completed', current: _filter, onTap: (v) => setState(() => _filter = v)),
                ],
              ),
            ),

            // ── List ──────────────────────────────────────────────────────────
            Expanded(
              child: projects.isEmpty
                  ? _EmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                      itemCount: projects.length,
                      itemBuilder: (_, i) => ProjectCard(
                        project: projects[i],
                        wide: true,
                        onTap: () => context.push('/project/${projects[i].id}'),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Local widgets ─────────────────────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _IconBtn({required this.icon, this.onTap});

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
        child: Icon(icon, size: 20, color: AppColors.ink900),
      ),
    );
  }
}

class _FilledIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _FilledIconBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: AppColors.teal700, borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: AppColors.teal700.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Icon(icon, size: 20, color: Colors.white),
      ),
    );
  }
}

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
      child: Row(
        children: [
          const Padding(padding: EdgeInsets.symmetric(horizontal: 14), child: Icon(Icons.search_rounded, size: 18, color: AppColors.ink400)),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(fontSize: 14, color: AppColors.ink900),
              decoration: const InputDecoration(
                hintText: 'Search projects',
                hintStyle: TextStyle(color: AppColors.ink400, fontSize: 14),
                border: InputBorder.none, contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String id;
  final String current;
  final ValueChanged<String> onTap;

  const _FilterChip({required this.label, required this.id, required this.current, required this.onTap});

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
        child: Text(label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: sel ? Colors.white : AppColors.ink700)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56, height: 56,
              decoration: const BoxDecoration(color: AppColors.teal50, shape: BoxShape.circle),
              child: const Icon(Icons.folder_open_rounded, size: 28, color: AppColors.teal700),
            ),
            const SizedBox(height: 12),
            const Text('Nothing here yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink900)),
            const SizedBox(height: 6),
            const Text('Try a different filter or create a project.', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.ink500)),
          ],
        ),
      ),
    );
  }
}
