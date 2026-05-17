import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/data/seed_data.dart';
import 'widgets.dart';

class ProjectInfoScreen extends StatefulWidget {
  final String projectId;
  const ProjectInfoScreen({super.key, required this.projectId});

  @override
  State<ProjectInfoScreen> createState() => _ProjectInfoScreenState();
}

class _ProjectInfoScreenState extends State<ProjectInfoScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  late AppProject _project;
  late List<AppTask> _tasks;
  late List<AppMessage> _messages;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _project = SeedData.projects.firstWhere((p) => p.id == widget.projectId, orElse: () => SeedData.projects.first);
    _tasks    = List.from(SeedData.tasks[widget.projectId] ?? SeedData.tasks['p1'] ?? []);
    _messages = List.from(SeedData.messages[widget.projectId] ?? SeedData.messages['p1'] ?? []);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  // ── Task helpers ──────────────────────────────────────────────────────────────

  void _advanceTask(AppTask t) {
    const order = ['todo', 'progress', 'done'];
    final idx = order.indexOf(t.status);
    if (idx < order.length - 1) setState(() => t.status = order[idx + 1]);
  }

  void _showAddTaskSheet() => _showTaskSheet();

  void _showTaskSheet({AppTask? existing}) {
    final titleCtrl    = TextEditingController(text: existing?.title ?? '');
    final categoryCtrl = TextEditingController(text: existing?.category ?? '');
    final dueCtrl      = TextEditingController(text: existing?.due ?? '');
    String priority    = existing?.priority ?? 'Normal';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
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
                Center(child: Container(width: 36, height: 4,
                  decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Text(existing == null ? 'New Task' : 'Edit Task',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink900)),
                const SizedBox(height: 20),
                _SheetField(label: 'TITLE', hint: 'What needs to be done?', controller: titleCtrl),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _SheetField(label: 'CATEGORY', hint: 'General', controller: categoryCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: _SheetField(label: 'DUE DATE', hint: 'e.g. May 20', controller: dueCtrl)),
                ]),
                const SizedBox(height: 12),
                const Text('PRIORITY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppColors.ink500)),
                const SizedBox(height: 6),
                Row(children: ['Normal', 'High'].map((p) {
                  final sel = priority == p;
                  final color = p == 'High' ? AppColors.warm600 : AppColors.teal700;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setModal(() => priority = p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? color.withValues(alpha: 0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: sel ? color : AppColors.line, width: sel ? 1.5 : 1),
                        ),
                        child: Text(p, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                          color: sel ? color : AppColors.ink500)),
                      ),
                    ),
                  );
                }).toList()),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      final title = titleCtrl.text.trim();
                      if (title.isEmpty) return;
                      setState(() {
                        if (existing == null) {
                          _tasks.add(AppTask(
                            id: 't${DateTime.now().millisecondsSinceEpoch}',
                            title: title,
                            category: categoryCtrl.text.trim().isEmpty ? 'General' : categoryCtrl.text.trim(),
                            status: 'todo',
                            due: dueCtrl.text.trim().isEmpty ? '—' : dueCtrl.text.trim(),
                            priority: priority == 'High' ? 'High' : null,
                            assignees: [],
                          ));
                        } else {
                          final idx = _tasks.indexOf(existing);
                          if (idx != -1) {
                            _tasks[idx] = AppTask(
                              id: existing.id,
                              title: title,
                              category: categoryCtrl.text.trim().isEmpty ? existing.category : categoryCtrl.text.trim(),
                              status: existing.status,
                              due: dueCtrl.text.trim().isEmpty ? existing.due : dueCtrl.text.trim(),
                              priority: priority == 'High' ? 'High' : null,
                              assignees: existing.assignees,
                            );
                          }
                        }
                      });
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: AppTheme.primaryGradient,
                      ),
                      child: Text(existing == null ? 'Create Task' : 'Save Changes',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDeleteTask(AppTask t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete task?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        content: Text('Remove "${t.title}"?', style: const TextStyle(fontSize: 13, color: AppColors.ink500)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () { setState(() => _tasks.remove(t)); Navigator.of(ctx).pop(); },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ── Member helpers ─────────────────────────────────────────────────────────────

  void _showInviteMemberSheet() {
    final alreadyIn = _project.members.map((m) => m.id).toSet();
    final candidates = SeedData.discoverUsers.where((u) => !alreadyIn.contains(u.id)).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 36, height: 4,
              decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            const Text('Invite Member', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink900)),
            const SizedBox(height: 14),
            if (candidates.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('No more users to invite.', style: TextStyle(color: AppColors.ink500))),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: candidates.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.lineSoft),
                  itemBuilder: (ctx, i) {
                    final u = candidates[i];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: UserAvatar(name: u.name, size: 40, status: u.status),
                      title: Text(u.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink900)),
                      subtitle: Text(u.role, style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
                      trailing: GestureDetector(
                        onTap: () {
                          setState(() {
                            _project = _project.copyWith(members: [
                              ..._project.members,
                              ProjectMember(id: u.id, name: u.name, role: 'Member', status: u.status),
                            ]);
                          });
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${u.name} added to the project'),
                            backgroundColor: AppColors.teal700,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.teal50, borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.teal100),
                          ),
                          child: const Text('Add', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.teal700)),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmRemoveMember(ProjectMember m) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove member?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        content: Text('Remove ${m.name} from this project?', style: const TextStyle(fontSize: 13, color: AppColors.ink500)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _project = _project.copyWith(
                members: _project.members.where((x) => x.id != m.id).toList()));
              Navigator.of(ctx).pop();
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditRoleDialog(ProjectMember m) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Role for ${m.name}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
        children: ['Member', 'Reviewer', 'Lead', 'Owner'].map((r) => SimpleDialogOption(
          onPressed: () {
            setState(() {
              final updated = _project.members.map((x) => x.id == m.id ? x.copyWith(role: r) : x).toList();
              _project = _project.copyWith(members: updated);
            });
            Navigator.of(ctx).pop();
          },
          child: Text(r, style: TextStyle(
            fontWeight: m.role == r ? FontWeight.w800 : FontWeight.w500,
            color: m.role == r ? AppColors.teal700 : AppColors.ink900,
          )),
        )).toList(),
      ),
    );
  }

  // ── Message helpers ────────────────────────────────────────────────────────────

  void _confirmDeleteMessage(AppMessage msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete message?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        content: const Text('This will remove the message for everyone.', style: TextStyle(fontSize: 13, color: AppColors.ink500)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () { setState(() => _messages.remove(msg)); Navigator.of(ctx).pop(); },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.line), boxShadow: AppTheme.shadowSm,
                  ),
                  child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.ink900),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_project.name,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.3)),
                Text('${_project.status} · ${_project.members.length} members',
                  style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
              ])),
              _HeaderBtn(icon: Icons.forum_outlined, onTap: () => _tabCtrl.animateTo(3)),
              const SizedBox(width: 8),
              _HeaderBtn(icon: Icons.more_horiz_rounded, onTap: () {}),
            ]),
          ),

          // ── Tab bar ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: TabBar(
              controller: _tabCtrl,
              labelColor: AppColors.teal700,
              unselectedLabelColor: AppColors.ink500,
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              indicatorColor: AppColors.teal700,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: AppColors.lineSoft,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Tasks'),
                Tab(text: 'Members'),
                Tab(text: 'Chat'),
              ],
            ),
          ),

          // ── Content ───────────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _OverviewTab(
                  project: _project,
                  onAddTask: _showAddTaskSheet,
                  onInvite: _showInviteMemberSheet,
                  onOpenChat: () => _tabCtrl.animateTo(3),
                ),
                _TasksTab(
                  project: _project,
                  tasks: _tasks,
                  onAdvance: _advanceTask,
                  onToggle: (t) => setState(() { t.status = t.status == 'done' ? 'todo' : 'done'; }),
                  onAddTask: _showAddTaskSheet,
                  onEditTask: (t) => _showTaskSheet(existing: t),
                  onDeleteTask: _confirmDeleteTask,
                ),
                _MembersTab(
                  project: _project,
                  onInvite: _showInviteMemberSheet,
                  onRemove: _confirmRemoveMember,
                  onEditRole: _showEditRoleDialog,
                ),
                _ChatTab(
                  project: _project,
                  messages: _messages,
                  onSend: (text) => setState(() {
                    _messages.add(AppMessage(
                      id: 'm${DateTime.now().millisecondsSinceEpoch}',
                      userId: SeedData.currentUser.id,
                      text: text,
                      time: 'now',
                    ));
                  }),
                  onDelete: _confirmDeleteMessage,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Overview tab ──────────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final AppProject project;
  final VoidCallback onAddTask;
  final VoidCallback onInvite;
  final VoidCallback onOpenChat;
  const _OverviewTab({required this.project, required this.onAddTask, required this.onInvite, required this.onOpenChat});

  @override
  Widget build(BuildContext context) {
    final total = project.taskCounts.total;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      children: [
        Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: project.iconBg, borderRadius: BorderRadius.circular(14)),
            child: Icon(project.icon, size: 26, color: AppColors.teal700),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(project.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.3)),
            const SizedBox(height: 6),
            Wrap(spacing: 6, children: project.tags.map((t) => _Tag(t)).toList()),
          ])),
        ]),
        const SizedBox(height: 12),
        Text(project.description, style: const TextStyle(fontSize: 13, color: AppColors.ink700, height: 1.5)),

        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22), gradient: AppTheme.primaryGradient,
            boxShadow: AppTheme.shadowMd,
          ),
          child: Row(children: [
            ProgressRing(value: project.progress, size: 64, stroke: 6),
            const SizedBox(width: 18),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Overall progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 2),
              Text('${project.taskCounts.done} of $total tasks complete',
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
            ])),
          ]),
        ),

        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.warm100, borderRadius: BorderRadius.circular(20)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('URGENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.warm700, letterSpacing: 0.8)),
              Text('${project.taskCounts.progress}',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.warm700)),
              const Text('tasks in progress', style: TextStyle(fontSize: 11, color: AppColors.warm700)),
            ]),
          )),
          const SizedBox(width: 12),
          Expanded(child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.teal100, borderRadius: BorderRadius.circular(20)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('TEAM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.teal700, letterSpacing: 0.8)),
              const SizedBox(height: 8),
              AvatarStack(members: project.members, size: 26, max: 4),
              const SizedBox(height: 8),
              Text('${project.members.length} members', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.teal700)),
            ]),
          )),
        ]),

        const SectionHeader(title: 'Quick actions'),
        GridView.count(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
          childAspectRatio: 3.5, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          children: [
            _QuickAction(icon: Icons.add_task_rounded,         label: 'Add task',   onTap: onAddTask),
            _QuickAction(icon: Icons.person_add_alt_1_rounded, label: 'Invite',     onTap: onInvite),
            _QuickAction(icon: Icons.forum_outlined,           label: 'Open chat',  onTap: onOpenChat),
            _QuickAction(icon: Icons.edit_outlined,            label: 'Edit info',  onTap: () {}),
          ],
        ),

        const SectionHeader(title: 'Recent activity'),
        ...[
          (Icons.check_circle_outline_rounded, 'Priya marked "Asset pack export" as done', '12m ago', AppColors.success100, AppColors.success700),
          (Icons.chat_bubble_outline_rounded,  'Mira pushed an update to the design doc',  '1h ago',  const Color(0xFFE8F4FA), const Color(0xFF0E5B85)),
          (Icons.person_add_alt_1_rounded,     'Léo joined the project',                    '3h ago',  AppColors.teal50, AppColors.teal700),
        ].map((a) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lineSoft),
          ),
          child: Row(children: [
            Container(width: 30, height: 30, decoration: BoxDecoration(color: a.$4, borderRadius: BorderRadius.circular(10)),
              child: Icon(a.$1, size: 16, color: a.$5)),
            const SizedBox(width: 12),
            Expanded(child: Text(a.$2, style: const TextStyle(fontSize: 12, color: AppColors.ink700))),
            Text(a.$3, style: const TextStyle(fontSize: 10, color: AppColors.ink400)),
          ]),
        )),
      ],
    );
  }
}

// ── Tasks tab ─────────────────────────────────────────────────────────────────
class _TasksTab extends StatefulWidget {
  final AppProject project;
  final List<AppTask> tasks;
  final ValueChanged<AppTask> onAdvance;
  final ValueChanged<AppTask> onToggle;
  final VoidCallback onAddTask;
  final ValueChanged<AppTask> onEditTask;
  final ValueChanged<AppTask> onDeleteTask;

  const _TasksTab({
    required this.project, required this.tasks,
    required this.onAdvance, required this.onToggle,
    required this.onAddTask, required this.onEditTask, required this.onDeleteTask,
  });

  @override
  State<_TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<_TasksTab> {
  String _view = 'board';

  Map<String, List<AppTask>> get _byStatus => {
    'todo':     widget.tasks.where((t) => t.status == 'todo').toList(),
    'progress': widget.tasks.where((t) => t.status == 'progress').toList(),
    'done':     widget.tasks.where((t) => t.status == 'done').toList(),
  };

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _SegmentedToggle(value: _view,
            options: const [('board', 'Board'), ('list', 'List')],
            onChange: (v) => setState(() => _view = v)),
          _AddBtn(onTap: widget.onAddTask),
        ]),
      ),
      Expanded(child: _view == 'board'
        ? _BoardView(byStatus: _byStatus, onAdvance: widget.onAdvance,
            onEdit: widget.onEditTask, onDelete: widget.onDeleteTask)
        : _ListTaskView(tasks: widget.tasks, onToggle: widget.onToggle,
            onEdit: widget.onEditTask, onDelete: widget.onDeleteTask)),
    ]);
  }
}

class _BoardView extends StatelessWidget {
  final Map<String, List<AppTask>> byStatus;
  final ValueChanged<AppTask> onAdvance;
  final ValueChanged<AppTask> onEdit;
  final ValueChanged<AppTask> onDelete;
  const _BoardView({required this.byStatus, required this.onAdvance, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    const cols = [
      ('todo',     'To Do',       AppColors.ink500),
      ('progress', 'In Progress', AppColors.warm700),
      ('done',     'Done',        AppColors.success700),
    ];
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
      children: cols.map((col) {
        final tasks = byStatus[col.$1] ?? [];
        return Container(
          width: 260, margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.bgAlt, borderRadius: BorderRadius.circular(20)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(col.$2, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: col.$3)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(99), border: Border.all(color: AppColors.line)),
                child: Text('${tasks.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.ink700)),
              ),
            ]),
            const SizedBox(height: 10),
            ...tasks.map((t) => _KanbanCard(task: t, onAdvance: () => onAdvance(t),
              onEdit: () => onEdit(t), onDelete: () => onDelete(t))),
          ]),
        );
      }).toList(),
    );
  }
}

class _ListTaskView extends StatelessWidget {
  final List<AppTask> tasks;
  final ValueChanged<AppTask> onToggle;
  final ValueChanged<AppTask> onEdit;
  final ValueChanged<AppTask> onDelete;
  const _ListTaskView({required this.tasks, required this.onToggle, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
      itemCount: tasks.length,
      itemBuilder: (_, i) => GestureDetector(
        onLongPress: () => _showTaskOptions(context, tasks[i]),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TaskRow(task: tasks[i], onToggle: () => onToggle(tasks[i])),
        ),
      ),
    );
  }

  void _showTaskOptions(BuildContext context, AppTask t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined, color: AppColors.teal700),
            title: const Text('Edit task', style: TextStyle(fontWeight: FontWeight.w700)),
            onTap: () { Navigator.of(ctx).pop(); onEdit(t); },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            title: const Text('Delete task', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.red)),
            onTap: () { Navigator.of(ctx).pop(); onDelete(t); },
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

class _KanbanCard extends StatelessWidget {
  final AppTask task;
  final VoidCallback onAdvance;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _KanbanCard({required this.task, required this.onAdvance, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isHigh = task.priority == 'High';
    final isDone = task.status == 'done';
    return GestureDetector(
      onLongPress: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: AppColors.teal700),
              title: const Text('Edit task', style: TextStyle(fontWeight: FontWeight.w700)),
              onTap: () { Navigator.of(ctx).pop(); onEdit(); },
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              title: const Text('Delete task', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.red)),
              onTap: () { Navigator.of(ctx).pop(); onDelete(); },
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(color: isHigh ? AppColors.warm600 : AppColors.lineSoft, width: isHigh ? 3 : 1),
            top: BorderSide(color: AppColors.lineSoft),
            right: BorderSide(color: AppColors.lineSoft),
            bottom: BorderSide(color: AppColors.lineSoft),
          ),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isHigh ? AppColors.warm100 : AppColors.teal50,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(task.category,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isHigh ? AppColors.warm700 : AppColors.teal700)),
            ),
            if (isHigh) const Icon(Icons.flag_rounded, size: 14, color: AppColors.warm600),
          ]),
          const SizedBox(height: 8),
          Text(task.title,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink900,
              decoration: isDone ? TextDecoration.lineThrough : null, decorationColor: AppColors.ink500)),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              const Icon(Icons.schedule_rounded, size: 13, color: AppColors.ink500),
              const SizedBox(width: 4),
              Text(task.due, style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
            ]),
            if (!isDone)
              GestureDetector(
                onTap: onAdvance,
                child: Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.line), color: Colors.white),
                  child: const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.teal700),
                ),
              ),
          ]),
        ]),
      ),
    );
  }
}

// ── Members tab ───────────────────────────────────────────────────────────────
class _MembersTab extends StatelessWidget {
  final AppProject project;
  final VoidCallback onInvite;
  final ValueChanged<ProjectMember> onRemove;
  final ValueChanged<ProjectMember> onEditRole;
  const _MembersTab({required this.project, required this.onInvite, required this.onRemove, required this.onEditRole});

  @override
  Widget build(BuildContext context) {
    final isOwner = project.ownerId == SeedData.currentUser.id;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Members (${project.members.length})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink900)),
          _AddBtn(label: 'Invite', onTap: onInvite),
        ]),
        const SizedBox(height: 14),
        ...project.members.map((m) => _MemberCard(
          member: m,
          isSelf: m.id == SeedData.currentUser.id,
          isOwner: isOwner,
          onRemove: () => onRemove(m),
          onEditRole: () => onEditRole(m),
        )),
        if (!isOwner) ...[
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.go('/projects'),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF4C3C3)),
              ),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.logout_rounded, size: 18, color: Color(0xFF9B1C1C)),
                SizedBox(width: 8),
                Text('Leave project', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9B1C1C))),
              ]),
            ),
          ),
        ],
      ],
    );
  }
}

class _MemberCard extends StatelessWidget {
  final ProjectMember member;
  final bool isSelf;
  final bool isOwner;
  final VoidCallback onRemove;
  final VoidCallback onEditRole;
  const _MemberCard({required this.member, required this.isSelf, required this.isOwner, required this.onRemove, required this.onEditRole});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lineSoft), boxShadow: AppTheme.shadowSm,
      ),
      child: Row(children: [
        UserAvatar(name: member.name, size: 42, status: member.status),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(member.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.ink900)),
            if (isSelf) const Text(' (you)', style: TextStyle(fontSize: 12, color: AppColors.ink400, fontWeight: FontWeight.w600)),
          ]),
          Text(member.role, style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
        ])),
        GestureDetector(
          onTap: isOwner && !isSelf ? onEditRole : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.bgAlt, borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(member.role, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.ink700)),
              if (isOwner && !isSelf) ...[
                const SizedBox(width: 4),
                const Icon(Icons.expand_more_rounded, size: 14, color: AppColors.ink400),
              ],
            ]),
          ),
        ),
        if (isOwner && !isSelf) ...[
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFF4C3C3)),
              ),
              child: const Icon(Icons.person_remove_outlined, size: 14, color: Color(0xFF9B1C1C)),
            ),
          ),
        ],
      ]),
    );
  }
}

// ── Chat tab ──────────────────────────────────────────────────────────────────
class _ChatTab extends StatefulWidget {
  final AppProject project;
  final List<AppMessage> messages;
  final ValueChanged<String> onSend;
  final ValueChanged<AppMessage> onDelete;
  const _ChatTab({required this.project, required this.messages, required this.onSend, required this.onDelete});

  @override
  State<_ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<_ChatTab> {
  final _ctrl   = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _ctrl.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  ProjectMember? _memberFor(String userId) =>
      widget.project.members.where((m) => m.id == userId).firstOrNull;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.builder(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          itemCount: widget.messages.length,
          itemBuilder: (_, i) {
            final msg = widget.messages[i];
            final isMe = msg.userId == SeedData.currentUser.id;
            final sender = isMe ? SeedData.currentUser.name : (_memberFor(msg.userId)?.name ?? msg.userId);
            return _Bubble(
              text: msg.text, time: msg.time, isMe: isMe, senderName: sender,
              onLongPress: () => widget.onDelete(msg),
            );
          },
        ),
      ),

      Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        decoration: BoxDecoration(
          color: AppColors.bg.withValues(alpha: 0.95),
          border: const Border(top: BorderSide(color: AppColors.lineSoft)),
        ),
        child: Row(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
              ),
              child: TextField(
                controller: _ctrl,
                onSubmitted: (_) => _send(),
                style: const TextStyle(fontSize: 14, color: AppColors.ink900),
                decoration: const InputDecoration(
                  hintText: 'Message #project',
                  hintStyle: TextStyle(color: AppColors.ink400, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _send,
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle, gradient: AppTheme.primaryGradient,
                boxShadow: [BoxShadow(color: AppColors.teal700.withValues(alpha: 0.25), blurRadius: 14, offset: const Offset(0, 6))],
              ),
              child: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
            ),
          ),
        ]),
      ),
    ]);
  }
}

class _Bubble extends StatelessWidget {
  final String text, time, senderName;
  final bool isMe;
  final VoidCallback onLongPress;
  const _Bubble({required this.text, required this.time, required this.senderName, required this.isMe, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMe) ...[
              UserAvatar(name: senderName, size: 28),
              const SizedBox(width: 8),
            ],
            Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe) Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 2),
                  child: Text(senderName, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.ink500)),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.teal700 : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft:     const Radius.circular(18),
                      topRight:    const Radius.circular(18),
                      bottomLeft:  Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                    border: isMe ? null : Border.all(color: AppColors.lineSoft),
                    boxShadow: AppTheme.shadowSm,
                  ),
                  child: Text(text, style: TextStyle(fontSize: 13, color: isMe ? Colors.white : AppColors.ink900, height: 1.4)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 12, right: 12),
                  child: Text(time, style: const TextStyle(fontSize: 9, color: AppColors.ink400)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared small widgets ───────────────────────────────────────────────────────

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.teal50, borderRadius: BorderRadius.circular(999), border: Border.all(color: AppColors.teal100)),
      child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.teal700)),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.lineSoft), boxShadow: AppTheme.shadowSm,
        ),
        child: Row(children: [
          Icon(icon, size: 18, color: AppColors.teal700),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink900)),
        ]),
      ),
    );
  }
}

class _AddBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _AddBtn({this.label = 'Task', required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), gradient: AppTheme.primaryGradient,
          boxShadow: [BoxShadow(color: AppColors.teal700.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.add_rounded, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
        ]),
      ),
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
      decoration: BoxDecoration(color: AppColors.bgAlt, borderRadius: BorderRadius.circular(12)),
      child: Row(children: options.map((o) {
        final sel = value == o.$1;
        return GestureDetector(
          onTap: () => onChange(o.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: sel ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: sel ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 3)] : null,
            ),
            child: Text(o.$2,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: sel ? AppColors.ink900 : AppColors.ink500)),
          ),
        );
      }).toList()),
    );
  }
}

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

class _SheetField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  const _SheetField({required this.label, required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppColors.ink500)),
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgAlt, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: TextField(
            controller: controller,
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
