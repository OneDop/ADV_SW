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
    _tasks   = List.from(SeedData.tasks[widget.projectId] ?? SeedData.tasks['p1'] ?? []);
    _messages = List.from(SeedData.messages[widget.projectId] ?? SeedData.messages['p1'] ?? []);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  void _advanceTask(AppTask t) {
    const order = ['todo', 'progress', 'done'];
    final idx = order.indexOf(t.status);
    if (idx < order.length - 1) {
      setState(() => t.status = order[idx + 1]);
    }
  }

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
                _OverviewTab(project: _project),
                _TasksTab(project: _project, tasks: _tasks, onAdvance: _advanceTask,
                  onToggle: (t) => setState(() { t.status = t.status == 'done' ? 'todo' : 'done'; })),
                _MembersTab(project: _project),
                _ChatTab(project: _project, messages: _messages,
                  onSend: (text) => setState(() {
                    _messages.add(AppMessage(id: 'm${DateTime.now().millisecondsSinceEpoch}',
                      userId: SeedData.currentUser.id, text: text, time: 'now'));
                  })),
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
  const _OverviewTab({required this.project});

  @override
  Widget build(BuildContext context) {
    final total = project.taskCounts.total;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      children: [
        // Project heading
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

        // Progress bento
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

        // Bento row
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

        // Quick actions
        const SectionHeader(title: 'Quick actions'),
        GridView.count(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
          childAspectRatio: 3.5, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          children: [
            _QuickAction(icon: Icons.add_task_rounded, label: 'Add task', onTap: () {}),
            _QuickAction(icon: Icons.person_add_alt_1_rounded, label: 'Invite', onTap: () {}),
            _QuickAction(icon: Icons.forum_outlined, label: 'Open chat', onTap: () {}),
            _QuickAction(icon: Icons.edit_outlined, label: 'Edit info', onTap: () {}),
          ],
        ),

        // Recent activity
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
  const _TasksTab({required this.project, required this.tasks, required this.onAdvance, required this.onToggle});

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
          _AddBtn(onTap: () {}),
        ]),
      ),
      Expanded(child: _view == 'board' ? _BoardView(byStatus: _byStatus, onAdvance: widget.onAdvance)
                                       : _ListView(tasks: widget.tasks, onToggle: widget.onToggle)),
    ]);
  }
}

class _BoardView extends StatelessWidget {
  final Map<String, List<AppTask>> byStatus;
  final ValueChanged<AppTask> onAdvance;
  const _BoardView({required this.byStatus, required this.onAdvance});

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
            ...tasks.map((t) => _KanbanCard(task: t, onAdvance: () => onAdvance(t))),
            const SizedBox(height: 6),
            _AddColumnBtn(onTap: () {}),
          ]),
        );
      }).toList(),
    );
  }
}

class _ListView extends StatelessWidget {
  final List<AppTask> tasks;
  final ValueChanged<AppTask> onToggle;
  const _ListView({required this.tasks, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
      itemCount: tasks.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TaskRow(task: tasks[i], onToggle: () => onToggle(tasks[i])),
      ),
    );
  }
}

class _KanbanCard extends StatelessWidget {
  final AppTask task;
  final VoidCallback onAdvance;
  const _KanbanCard({required this.task, required this.onAdvance});

  @override
  Widget build(BuildContext context) {
    final isHigh = task.priority == 'High';
    final isDone = task.status == 'done';
    return Container(
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
    );
  }
}

// ── Members tab ───────────────────────────────────────────────────────────────
class _MembersTab extends StatelessWidget {
  final AppProject project;
  const _MembersTab({required this.project});

  @override
  Widget build(BuildContext context) {
    final isOwner = project.ownerId == SeedData.currentUser.id;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Members (${project.members.length})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink900)),
          _AddBtn(label: 'Invite', onTap: () {}),
        ]),
        const SizedBox(height: 14),
        ...project.members.map((m) => _MemberCard(
          member: m,
          isSelf: m.id == SeedData.currentUser.id,
          isOwner: isOwner,
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
  const _MemberCard({required this.member, required this.isSelf, required this.isOwner});

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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.bgAlt, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: Text(member.role, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.ink700)),
        ),
      ]),
    );
  }
}

// ── Chat tab ──────────────────────────────────────────────────────────────────
class _ChatTab extends StatefulWidget {
  final AppProject project;
  final List<AppMessage> messages;
  final ValueChanged<String> onSend;
  const _ChatTab({required this.project, required this.messages, required this.onSend});

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
            return _Bubble(text: msg.text, time: msg.time, isMe: isMe, senderName: sender);
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
  const _Bubble({required this.text, required this.time, required this.senderName, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
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

class _AddColumnBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _AddColumnBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.ink300, width: 1.5, style: BorderStyle.solid),
        ),
        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.add_rounded, size: 14, color: AppColors.ink500),
          SizedBox(width: 4),
          Text('Add', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink500)),
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
