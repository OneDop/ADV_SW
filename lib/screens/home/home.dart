import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/data/seed_data.dart';
import 'widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<AppTask> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(SeedData.tasks['p1'] ?? []);
  }

  void _toggleTask(AppTask t) {
    setState(() {
      t.status = t.status == 'done' ? 'todo' : 'done';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = SeedData.currentUser;
    final myProjects = SeedData.projects.where((p) => p.members.any((m) => m.id == user.id)).toList();
    final pendingTasks = _tasks.where((t) => t.status != 'done').take(4).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App bar ──────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    UserAvatar(name: user.name, size: 42, status: user.status, ring: 2),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hi ${user.firstName}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.4)),
                          const Text('Thursday, May 15', style: TextStyle(fontSize: 11, color: AppColors.ink500)),
                        ],
                      ),
                    ),
                    _IconBtn(icon: Icons.search_rounded, onTap: () {
                      StatefulNavigationShell.of(context).goBranch(1);
                    }),
                    const SizedBox(width: 8),
                    _IconBtn(icon: Icons.notifications_none_rounded, onTap: () {
                      StatefulNavigationShell.of(context).goBranch(4);
                    }, badge: SeedData.notifications.length),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),

                  // ── Focus today hero ────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: AppTheme.primaryGradient,
                      boxShadow: [BoxShadow(color: AppColors.teal700.withValues(alpha: 0.25), blurRadius: 24, offset: const Offset(0, 10))],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -40, top: -40,
                          child: Container(
                            width: 160, height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(colors: [AppColors.aqua.withValues(alpha: 0.35), Colors.transparent]),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('FOCUS TODAY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: Colors.white70)),
                            const SizedBox(height: 6),
                            const Text('Wrap up encryption\nwork on Quantum',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, height: 1.15, letterSpacing: -0.3)),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('3 tasks · 1 due tomorrow', style: TextStyle(fontSize: 11, color: Colors.white70)),
                                      const SizedBox(height: 4),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(99),
                                        child: LinearProgressIndicator(
                                          value: 0.68, minHeight: 5,
                                          backgroundColor: Colors.white24,
                                          valueColor: const AlwaysStoppedAnimation(AppColors.aqua),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () => context.push('/project/p1'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white38),
                                    ),
                                    child: const Row(children: [
                                      Text('Open', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                                      SizedBox(width: 6),
                                      Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── My Projects ─────────────────────────────────────────────
                  SectionHeader(
                    title: 'My Projects',
                    action: 'View all',
                    onAction: () => StatefulNavigationShell.of(context).goBranch(2),
                  ),
                  SizedBox(
                    height: 196,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: myProjects.length + 1,
                      itemBuilder: (_, i) {
                        if (i == myProjects.length) {
                          return _NewProjectBtn(onTap: () {});
                        }
                        return ProjectCard(
                          project: myProjects[i],
                          onTap: () => context.push('/project/${myProjects[i].id}'),
                        );
                      },
                    ),
                  ),

                  // ── My Tasks ────────────────────────────────────────────────
                  SectionHeader(
                    title: 'My Tasks',
                    action: 'See all',
                    onAction: () => context.push('/project/p1'),
                  ),
                  ...pendingTasks.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TaskRow(task: t, onToggle: () => _toggleTask(t)),
                  )),

                  // ── This week ───────────────────────────────────────────────
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.teal700,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppTheme.shadowMd,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('This week', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                              SizedBox(height: 4),
                              Text('You completed 12 of 15 tasks. Streak: 4 days.',
                                style: TextStyle(fontSize: 12, color: Colors.white70)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const ProgressRing(value: 0.8),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 20, color: AppColors.ink900),
            if (badge != null && badge! > 0)
              Positioned(
                top: 6, right: 6,
                child: Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(color: const Color(0xFFE14B4B), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                  child: Center(child: Text(badge! > 9 ? '9+' : '$badge', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
              ),
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
        width: 220,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.ink300, width: 1.5, style: BorderStyle.solid),
          color: Colors.white.withValues(alpha: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_rounded, size: 28, color: AppColors.teal700),
            SizedBox(height: 8),
            Text('New project', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink500)),
          ],
        ),
      ),
    );
  }
}
