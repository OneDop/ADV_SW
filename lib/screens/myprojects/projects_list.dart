import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/providers/project_provider.dart';
import 'package:advsw/models/project_model.dart';
import 'widgets.dart';

class ProjectsListScreen extends ConsumerStatefulWidget {
  const ProjectsListScreen({super.key});

  @override
  ConsumerState<ProjectsListScreen> createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends ConsumerState<ProjectsListScreen> {
  String _filter = 'all';
  String _query = '';

  void _showCreateProjectSheet(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('New Project', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink900)),
                GestureDetector(onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded, color: AppColors.ink500)),
              ]),
              const SizedBox(height: 20),
              _SheetField(label: 'PROJECT NAME', hint: 'e.g. SkillSync App', controller: nameCtrl),
              const SizedBox(height: 14),
              _SheetField(label: 'DESCRIPTION', hint: 'What is this project about?', controller: descCtrl, maxLines: 3),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = nameCtrl.text.trim();
                    final desc = descCtrl.text.trim();
                    if (name.isEmpty) return;
                    Navigator.pop(context);
                    await ref.read(myProjectsProvider.notifier).createProject(
                      CreateProjectRequest(name: name, description: desc),
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

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(myProjectsProvider);

    return Scaffold(
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
                        projectsAsync.when(
                          data: (list) => Text('${list.length} total', style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
                          loading: () => const Text('Loading...', style: TextStyle(fontSize: 11, color: AppColors.ink500)),
                          error: (_, __) => const Text('Error', style: TextStyle(fontSize: 11, color: AppColors.ink500)),
                        ),
                      ],
                    ),
                  ),
                  _IconBtn(icon: Icons.filter_list_rounded, onTap: () {}),
                  const SizedBox(width: 8),
                  _FilledIconBtn(icon: Icons.add_rounded, onTap: () => _showCreateProjectSheet(context, ref)),
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
                  _FilterChip(label: 'Completed',     id: 'completed', current: _filter, onTap: (v) => setState(() => _filter = v)),
                ],
              ),
            ),

            // ── List ──────────────────────────────────────────────────────────
            Expanded(
              child: projectsAsync.when(
                data: (projects) {
                  var filtered = projects;
                  // Note: In a real app, filtering might be done via a provider or backend
                  if (_filter == 'completed') filtered = filtered.where((p) => p.status == ProjectStatus.COMPLETED).toList();
                  if (_query.isNotEmpty) filtered = filtered.where((p) => p.name.toLowerCase().contains(_query.toLowerCase())).toList();

                  if (filtered.isEmpty) return _EmptyState();

                  return RefreshIndicator(
                    onRefresh: () => ref.read(myProjectsProvider.notifier).refresh(),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final p = filtered[i];
                        return ProjectCardProxy(
                          project: p,
                          wide: true,
                          onTap: () => context.push('/project/${p.id}'),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A proxy widget to bridge ProjectResponse to the existing ProjectCard UI
class ProjectCardProxy extends StatelessWidget {
  final ProjectResponse project;
  final bool wide;
  final VoidCallback? onTap;

  const ProjectCardProxy({super.key, required this.project, this.wide = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Map ProjectResponse to AppProject (from SeedData for UI compatibility)
    // or just pass the data directly if we update ProjectCard.
    // For now, let's keep the UI consistent with a mapping or updated card.
    return ProjectCard(
      project: project, // I will update ProjectCard to handle ProjectResponse
      wide: wide,
      onTap: onTap,
    );
  }
}

// ── Local widgets (Keep existing local widgets) ──────────────────────────────────
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

class _SheetField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  const _SheetField({required this.label, required this.hint, required this.controller, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppColors.ink500)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgAlt, borderRadius: BorderRadius.circular(12),
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
        ),
      ],
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
