import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/data/seed_data.dart';
import 'package:advsw/theme/theme_manager.dart';
import 'package:advsw/screens/home/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([SeedData.profileNotifier, ThemeManager.instance]),
      builder: (context, _) {
        final eu = SeedData.editableUser;
        final cu = SeedData.currentUser;
        final myProjects = SeedData.projects.where((p) => p.members.any((m) => m.id == cu.id)).toList();

        final statusColor = eu.status == 'available'
            ? const Color(0xFF3BB273)
            : eu.status == 'busy'
                ? AppColors.warm600
                : AppColors.ink400;
        final statusLabel = eu.status[0].toUpperCase() + eu.status.substring(1);

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.4)),
                        Row(children: [
                          _HeaderBtn(
                            icon: ThemeManager.instance.isDark ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
                            onTap: () => ThemeManager.instance.toggle(),
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
                              UserAvatar(name: eu.name, size: 68, status: eu.status, ring: 3),
                              const SizedBox(width: 16),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(eu.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.3)),
                                const SizedBox(height: 2),
                                Text(cu.email, style: const TextStyle(fontSize: 11, color: Colors.white70)),
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
                            if (eu.bio.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(eu.bio, style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.5)),
                            ],
                            const SizedBox(height: 16),
                            Row(children: [
                              _HeroBtn(label: 'Edit profile', icon: Icons.edit_outlined, onTap: () => context.push('/edit-profile')),
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
                      SectionHeader(title: 'Skills', action: 'Edit', onAction: () => context.push('/edit-profile')),
                      Wrap(
                        spacing: 6, runSpacing: 8,
                        children: eu.skills.map((s) => _SkillTag(s, tone: 'accent')).toList(),
                      ),

                      // ── Experience ───────────────────────────────────────────────
                      const SectionHeader(title: 'Experience'),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.lineSoft), boxShadow: AppTheme.shadowSm,
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(eu.experience, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.ink900)),
                          const SizedBox(height: 4),
                          const Text('Set your experience level so collaborators know what to expect.',
                            style: TextStyle(fontSize: 12, color: AppColors.ink500)),
                        ]),
                      ),

                      // ── Past projects ────────────────────────────────────────────
                      SectionHeader(title: 'Past projects', action: '+ Add', onAction: () => context.push('/edit-profile')),
                      ...eu.pastProjects.map((p) => _PastProjectRow(name: p)),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line), boxShadow: AppTheme.shadowSm,
        ),
        child: Icon(icon, size: 20, color: AppColors.ink700),
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.lineSoft), boxShadow: AppTheme.shadowSm,
        ),
        child: Column(children: [
          Icon(icon, size: 18, color: AppColors.teal700),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink900)),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.ink500)),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAccent ? AppColors.teal50 : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: isAccent ? AppColors.teal100 : AppColors.line),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isAccent ? AppColors.teal700 : AppColors.ink700)),
    );
  }
}

class _PastProjectRow extends StatelessWidget {
  final String name;
  const _PastProjectRow({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lineSoft), boxShadow: AppTheme.shadowSm,
      ),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: AppColors.teal50, borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.bookmark_border_rounded, size: 16, color: AppColors.teal700),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink900))),
        const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.ink400),
      ]),
    );
  }
}
