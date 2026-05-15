import 'package:advsw/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/data/seed_data.dart';
import 'package:advsw/screens/home/widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final u = SeedData.currentUser;
    final myProjects = SeedData.projects.where((p) => p.members.any((m) => m.id == u.id)).toList();
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface, letterSpacing: -0.4)),
                    Row(children: [
                      Switch(
                        value: isDark,
                        onChanged: (val) => ref.read(themeProvider.notifier).toggleTheme(),
                        activeColor: AppColors.teal500,
                      ),
                      const SizedBox(width: 8),
                      _HeaderBtn(icon: Icons.logout_rounded, onTap: () => context.go('/login')),
                    ]),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // ── Hero card ────────────────────────────────────────────────
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
                          UserAvatar(name: u.name, size: 68, status: u.status, ring: 3),
                          const SizedBox(width: 16),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(u.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.3)),
                            const SizedBox(height: 2),
                            Text(u.email, style: const TextStyle(fontSize: 11, color: Colors.white70)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(999)),
                              child: Row(mainAxisSize: MainAxisSize.min, children: const [
                                CircleAvatar(backgroundColor: Color(0xFF5BE6A4), radius: 3),
                                SizedBox(width: 6),
                                Text('Available', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                              ]),
                            ),
                          ])),
                        ]),
                        const SizedBox(height: 16),
                        Text(u.bio, style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.5)),
                        const SizedBox(height: 16),
                        Row(children: [
                          _HeroBtn(label: 'Edit profile', icon: Icons.edit_outlined, onTap: () {}),
                          const SizedBox(width: 8),
                          _HeroBtn(label: 'Share', icon: Icons.share_outlined, onTap: () {}, ghost: true),
                        ]),
                      ]),
                    ]),
                  ),

                  // ── Stats ────────────────────────────────────────────────────
                  const SizedBox(height: 16),
                  Row(children: [
                    _StatCard(icon: Icons.grid_view_rounded, value: '${myProjects.length}', label: 'Projects'),
                    const SizedBox(width: 10),
                    const _StatCard(icon: Icons.check_circle_outline_rounded, value: '84', label: 'Tasks done'),
                    const SizedBox(width: 10),
                    const _StatCard(icon: Icons.local_fire_department_rounded, value: '4d', label: 'Streak'),
                  ]),

                  // ── Skills ───────────────────────────────────────────────────
                  SectionHeader(title: 'Skills', action: 'Edit', onAction: () {}),
                  Wrap(
                    spacing: 6, runSpacing: 8,
                    children: u.skills.map((s) => _SkillTag(s, tone: 'accent')).toList(),
                  ),

                  // ── Experience ───────────────────────────────────────────────
                  const SectionHeader(title: 'Experience'),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: isDark ? Colors.white10 : AppColors.lineSoft), boxShadow: isDark ? [] : AppTheme.shadowSm,
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(u.experience, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface)),
                      const SizedBox(height: 4),
                      Text('Set your experience level so collaborators know what to expect.',
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                    ]),
                  ),

                  // ── Past projects ────────────────────────────────────────────
                  SectionHeader(title: 'Past projects', action: '+ Add', onAction: () {}),
                  ...u.pastProjects.map((p) => _PastProjectRow(name: p)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Local widgets ──────────────────────────────────────────────────────────────

class _HeaderBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.white10 : AppColors.line), boxShadow: isDark ? [] : AppTheme.shadowSm,
        ),
        child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}

class _HeroBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool ghost;
  const _HeroBtn({required this.label, required this.icon, required this.onTap, this.ghost = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: ghost ? Colors.white24 : Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12),
          border: ghost ? Border.all(color: Colors.white38) : null,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: ghost ? Colors.white : AppColors.ink900),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: ghost ? Colors.white : AppColors.ink900)),
        ]),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? Colors.white10 : AppColors.lineSoft), boxShadow: isDark ? [] : AppTheme.shadowSm,
        ),
        child: Column(children: [
          Icon(icon, size: 18, color: AppColors.teal500),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface)),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
        ]),
      ),
    );
  }
}

class _SkillTag extends StatelessWidget {
  final String label;
  final String tone;
  const _SkillTag(this.label, {this.tone = 'neutral'});

  @override
  Widget build(BuildContext context) {
    final isAccent = tone == 'accent';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAccent ? (isDark ? AppColors.teal900 : AppColors.teal50) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: isAccent ? (isDark ? AppColors.teal700 : AppColors.teal100) : (isDark ? Colors.white10 : AppColors.line)),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isAccent ? (isDark ? AppColors.aqua : AppColors.teal700) : theme.colorScheme.onSurface)),
    );
  }
}

class _PastProjectRow extends StatelessWidget {
  final String name;
  const _PastProjectRow({required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.lineSoft), boxShadow: isDark ? [] : AppTheme.shadowSm,
      ),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: isDark ? AppColors.teal900 : AppColors.teal50, borderRadius: BorderRadius.circular(10)),
          child: Icon(Icons.bookmark_border_rounded, size: 16, color: isDark ? AppColors.aqua : AppColors.teal700),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface))),
        Icon(Icons.chevron_right_rounded, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
      ]),
    );
  }
}
