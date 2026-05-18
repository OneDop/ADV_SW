import 'dart:async';
import 'package:advsw/models/project_model.dart';
import 'package:advsw/models/search_model.dart';
import 'package:advsw/models/task_model.dart';
import 'package:advsw/providers/chat_provider.dart';
import 'package:advsw/providers/invitation_provider.dart';
import 'package:advsw/providers/project_provider.dart';
import 'package:advsw/providers/task_provider.dart';
import 'package:advsw/providers/user_provider.dart';
import 'package:advsw/services/api_client.dart';
import 'package:advsw/services/search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'widgets.dart';

class ProjectInfoScreen extends ConsumerStatefulWidget {
  final String projectId;
  const ProjectInfoScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectInfoScreen> createState() => _ProjectInfoScreenState();
}

class _ProjectInfoScreenState extends ConsumerState<ProjectInfoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  late int _id;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _id = int.tryParse(widget.projectId) ?? 0;
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  void _showProjectOptions(BuildContext context, ProjectResponse project) {
    showModalBottomSheet(
      context: context,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Project Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink900,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.ink500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _OptionTile(
              icon: Icons.edit_outlined,
              label: 'Edit Project',
              onTap: () {
                Navigator.pop(ctx);
                _showEditProjectSheet(context, project);
              },
            ),
            const SizedBox(height: 8),
            _OptionTile(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Project',
              color: Colors.red,
              onTap: () {
                Navigator.pop(ctx);
                _showDeleteConfirmation(context, project);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProjectSheet(BuildContext context, ProjectResponse project) {
    final nameCtrl = TextEditingController(text: project.name);
    final descCtrl = TextEditingController(text: project.description);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Project',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink900,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.ink500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _SheetField(
                  label: 'NAME',
                  hint: 'Project name',
                  controller: nameCtrl,
                ),
                const SizedBox(height: 14),
                _SheetField(
                  label: 'DESCRIPTION',
                  hint: 'Project description...',
                  controller: descCtrl,
                  maxLines: 4,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final name = nameCtrl.text.trim();
                      if (name.isEmpty) return;
                      Navigator.pop(ctx);
                      await ref
                          .read(myProjectsProvider.notifier)
                          .updateProject(
                            _id,
                            UpdateProjectRequest(
                              name: name,
                              description: descCtrl.text.trim(),
                              status: project.status,
                            ),
                          );
                      ref.invalidate(projectDetailsProvider(_id));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
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

  void _showDeleteConfirmation(BuildContext context, ProjectResponse project) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Project',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.ink900,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${project.name}"? This action cannot be undone.',
          style: const TextStyle(color: AppColors.ink700, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.ink500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(myProjectsProvider.notifier).deleteProject(_id);
              if (mounted) context.pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectAsync = ref.watch(projectDetailsProvider(_id));
    final currentUserId = ref.watch(userProfileProvider).value?.id;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: projectAsync.when(
          data: (project) {
            final isOwner = project.ownerId == currentUserId;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.line),
                            boxShadow: AppTheme.shadowSm,
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 20,
                            color: AppColors.ink900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink900,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              '${project.status.name} · Owner: ${project.ownerName}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.ink500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _HeaderBtn(
                        icon: Icons.forum_outlined,
                        onTap: () => _tabCtrl.animateTo(3),
                      ),
                      if (isOwner) ...[
                        const SizedBox(width: 8),
                        _HeaderBtn(
                          icon: Icons.more_horiz_rounded,
                          onTap: () => _showProjectOptions(context, project),
                        ),
                      ],
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: TabBar(
                    controller: _tabCtrl,
                    labelColor: AppColors.teal700,
                    unselectedLabelColor: AppColors.ink500,
                    labelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
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

                Expanded(
                  child: TabBarView(
                    controller: _tabCtrl,
                    children: [
                      _OverviewTab(project: project),
                      _TasksTab(projectId: _id),
                      _MembersTab(projectId: _id, ownerId: project.ownerId),
                      _ChatTab(projectId: _id),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}

// ── Overview tab ──────────────────────────────────────────────────────────────
class _OverviewTab extends ConsumerWidget {
  final ProjectResponse project;
  const _OverviewTab({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(projectMembersProvider(project.id));
    final tasksAsync = ref.watch(projectTasksProvider(project.id));

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      children: [
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.teal50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.architecture,
                size: 26,
                color: AppColors.teal700,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink900,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Wrap(
                    spacing: 6,
                    children: [_Tag('Project'), _Tag('Active')],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          project.description,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.ink700,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: AppTheme.primaryGradient,
            boxShadow: AppTheme.shadowMd,
          ),
          child: Row(
            children: [
              const ProgressRing(value: 0.5, size: 64, stroke: 6),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overall progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    tasksAsync.when(
                      data: (tasks) => Text(
                        '${tasks.where((t) => t.status == TaskStatus.DONE).length} of ${tasks.length} tasks complete',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      loading: () => const Text(
                        'Loading tasks...',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                      error: (_, __) => const Text(
                        'Error loading tasks',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warm100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'STATUS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warm700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      project.status.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.warm700,
                      ),
                    ),
                    const Text(
                      'Current project status',
                      style: TextStyle(fontSize: 11, color: AppColors.warm700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.teal100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TEAM',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.teal700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    membersAsync.when(
                      data: (m) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AvatarStack(members: m, size: 26, max: 4),
                          const SizedBox(height: 8),
                          Text(
                            '${m.length} members',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.teal700,
                            ),
                          ),
                        ],
                      ),
                      loading: () => const Text(
                        '...',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.teal700,
                        ),
                      ),
                      error: (_, __) => const Text(
                        '!',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.teal700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Tasks tab ─────────────────────────────────────────────────────────────────
class _TasksTab extends ConsumerStatefulWidget {
  final int projectId;
  const _TasksTab({required this.projectId});

  @override
  ConsumerState<_TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends ConsumerState<_TasksTab> {
  String _view = 'board';
  int? _selectedAssigneeId;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        ref.read(projectTasksProvider(widget.projectId).notifier).refresh();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _showCreateTaskSheet(BuildContext context, AsyncValue<List<ProjectMemberResponse>> membersAsync) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    DateTime selectedDeadline = DateTime.now().add(const Duration(days: 7));
    _selectedAssigneeId = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'New Task',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink900,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.ink500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SheetField(
                    label: 'TITLE',
                    hint: 'e.g. Design login screen',
                    controller: titleCtrl,
                  ),
                  const SizedBox(height: 14),
                  _SheetField(
                    label: 'DESCRIPTION',
                    hint: 'Optional details...',
                    controller: descCtrl,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'ASSIGNEE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: AppColors.ink500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  membersAsync.when(
                    data: (members) {
                      final selectableMembers = members
                          .where((m) => m.memberRole != MemberRole.OWNER)
                          .toList();
                      if (selectableMembers.isEmpty) {
                        return Text(
                          'No members to assign',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.ink400,
                          ),
                        );
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgAlt,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _selectedAssigneeId,
                            hint: const Text(
                              'Select a member',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.ink400,
                              ),
                            ),
                            isExpanded: true,
                            items: selectableMembers.map((m) {
                              return DropdownMenuItem(
                                value: m.userId,
                                child: Text(
                                  '${m.firstName} ${m.lastName}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.ink900,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setModal(() => _selectedAssigneeId = val),
                          ),
                        ),
                      );
                    },
                    loading: () => const SizedBox(
                      height: 40,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => const Text(
                      'Failed to load members',
                      style: TextStyle(fontSize: 13, color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'DEADLINE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: AppColors.ink500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDeadline,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null)
                        setModal(() => selectedDeadline = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgAlt,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 16,
                            color: AppColors.teal700,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('MMM dd, yyyy').format(selectedDeadline),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.ink900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final title = titleCtrl.text.trim();
                        if (title.isEmpty) return;
                        Navigator.pop(ctx);

                        final newTask = await ref
                            .read(
                              projectTasksProvider(widget.projectId).notifier,
                            )
                            .createTask(
                              CreateTaskRequest(
                                title: title,
                                description: descCtrl.text.trim(),
                                deadline: selectedDeadline,
                              ),
                            );

                        if (_selectedAssigneeId != null && newTask != null) {
                          await ref
                              .read(
                                projectTasksProvider(widget.projectId).notifier,
                              )
                              .assignTask(newTask.id, _selectedAssigneeId!);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Create Task',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditTaskSheet(BuildContext context, TaskResponse task) {
    final titleCtrl = TextEditingController(text: task.title);
    final descCtrl = TextEditingController(text: task.description);
    DateTime selectedDeadline = task.deadline;
    int? assigneeId = task.assigneeId;
    final membersAsync = ref.read(projectMembersProvider(widget.projectId));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.75),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Edit Task', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink900)),
                      GestureDetector(onTap: () => Navigator.pop(ctx), child: const Icon(Icons.close_rounded, color: AppColors.ink500)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SheetField(label: 'TITLE', hint: 'Task title', controller: titleCtrl),
                  const SizedBox(height: 14),
                  _SheetField(label: 'DESCRIPTION', hint: 'Optional details...', controller: descCtrl, maxLines: 2),
                  const SizedBox(height: 14),
                  const Text('ASSIGNEE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppColors.ink500)),
                  const SizedBox(height: 6),
                  membersAsync.when(
                    data: (members) {
                      final selectable = members.where((m) => m.memberRole != MemberRole.OWNER).toList();
                      if (selectable.isEmpty) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.bgAlt, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.line)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: assigneeId,
                            hint: const Text('Select a member', style: TextStyle(fontSize: 14, color: AppColors.ink400)),
                            isExpanded: true,
                            items: selectable.map((m) => DropdownMenuItem(value: m.userId, child: Text('${m.firstName} ${m.lastName}', style: const TextStyle(fontSize: 14, color: AppColors.ink900)))).toList(),
                            onChanged: (val) => setModal(() => assigneeId = val),
                          ),
                        ),
                      );
                    },
                    loading: () => const SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 14),
                  const Text('DEADLINE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppColors.ink500)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(context: context, initialDate: selectedDeadline, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                      if (picked != null) setModal(() => selectedDeadline = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(color: AppColors.bgAlt, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.line)),
                      child: Row(children: [
                        const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.teal700),
                        const SizedBox(width: 10),
                        Text(DateFormat('MMM dd, yyyy').format(selectedDeadline), style: const TextStyle(fontSize: 14, color: AppColors.ink900, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final title = titleCtrl.text.trim();
                        if (title.isEmpty) return;
                        Navigator.pop(ctx);
                        await ref.read(projectTasksProvider(widget.projectId).notifier).updateTask(
                          task.id,
                          UpdateTaskRequest(title: title, description: descCtrl.text.trim(), status: task.status, deadline: selectedDeadline, assigneeId: assigneeId),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                      child: const Text('Save Changes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteTaskConfirmation(BuildContext context, TaskResponse task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Task', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink900)),
        content: Text('Delete "${task.title}"? This cannot be undone.', style: const TextStyle(color: AppColors.ink700, height: 1.5)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.ink500, fontWeight: FontWeight.w600))),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(projectTasksProvider(widget.projectId).notifier).deleteTask(task.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(projectTasksProvider(widget.projectId));
    final membersAsync = ref.watch(projectMembersProvider(widget.projectId));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SegmentedToggle(
                value: _view,
                options: const [('board', 'Board'), ('list', 'List')],
                onChange: (v) => setState(() => _view = v),
              ),
              _AddBtn(onTap: () => _showCreateTaskSheet(context, membersAsync)),
            ],
          ),
        ),
        Expanded(
          child: tasksAsync.when(
            data: (tasks) {
              if (_view == 'board') {
                final byStatus = {
                  'todo': tasks
                      .where((t) => t.status == TaskStatus.TODO)
                      .toList(),
                  'progress': tasks
                      .where((t) => t.status == TaskStatus.IN_PROGRESS)
                      .toList(),
                  'done': tasks
                      .where((t) => t.status == TaskStatus.DONE)
                      .toList(),
                };
                return _BoardView(
                  byStatus: byStatus,
                  onAdvance: (t) {
                    if (t.status == TaskStatus.TODO) {
                      ref.read(projectTasksProvider(widget.projectId).notifier)
                          .updateTaskStatus(t.id, TaskStatus.IN_PROGRESS);
                    } else if (t.status == TaskStatus.IN_PROGRESS) {
                      ref.read(projectTasksProvider(widget.projectId).notifier)
                          .updateTaskStatus(t.id, TaskStatus.DONE);
                    }
                  },
                  onGoBack: (t) {
                    if (t.status == TaskStatus.IN_PROGRESS) {
                      ref.read(projectTasksProvider(widget.projectId).notifier)
                          .updateTaskStatus(t.id, TaskStatus.TODO);
                    } else if (t.status == TaskStatus.DONE) {
                      ref.read(projectTasksProvider(widget.projectId).notifier)
                          .updateTaskStatus(t.id, TaskStatus.IN_PROGRESS);
                    }
                  },
                  onEdit: (t) => _showEditTaskSheet(context, t),
                  onDelete: (t) => _showDeleteTaskConfirmation(context, t),
                );
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                  itemCount: tasks.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TaskRow(
                      task: tasks[i],
                      onToggle: () {
                        final newStatus = tasks[i].status == TaskStatus.DONE
                            ? TaskStatus.TODO
                            : TaskStatus.DONE;
                        ref
                            .read(
                              projectTasksProvider(widget.projectId).notifier,
                            )
                            .updateTaskStatus(tasks[i].id, newStatus);
                      },
                      onEdit: () => _showEditTaskSheet(context, tasks[i]),
                      onDelete: () => _showDeleteTaskConfirmation(context, tasks[i]),
                    ),
                  ),
                );
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }
}

class _BoardView extends StatelessWidget {
  final Map<String, List<TaskResponse>> byStatus;
  final ValueChanged<TaskResponse> onAdvance;
  final ValueChanged<TaskResponse> onGoBack;
  final ValueChanged<TaskResponse> onEdit;
  final ValueChanged<TaskResponse> onDelete;
  const _BoardView({
    required this.byStatus,
    required this.onAdvance,
    required this.onGoBack,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const cols = [
      ('todo', 'To Do', AppColors.ink500),
      ('progress', 'In Progress', AppColors.warm700),
      ('done', 'Done', AppColors.success700),
    ];
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
      children: cols.map((col) {
        final tasks = byStatus[col.$1] ?? [];
        return Container(
          width: 260,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.bgAlt,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    col.$2,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: col.$3,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Text(
                      '${tasks.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: tasks
                      .map(
                        (t) => _KanbanCard(
                          task: t,
                          onAdvance: () => onAdvance(t),
                          onGoBack: () => onGoBack(t),
                          onEdit: () => onEdit(t),
                          onDelete: () => onDelete(t),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _KanbanCard extends StatelessWidget {
  final TaskResponse task;
  final VoidCallback onAdvance;
  final VoidCallback? onGoBack;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const _KanbanCard({
    required this.task,
    required this.onAdvance,
    this.onGoBack,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.DONE;
    final canGoBack = task.status == TaskStatus.IN_PROGRESS || isDone;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.teal50,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'TASK',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.teal700,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, size: 16, color: AppColors.ink400),
                padding: EdgeInsets.zero,
                onSelected: (v) {
                  if (v == 'edit') onEdit?.call();
                  if (v == 'delete') onDelete?.call();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            task.title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.ink900,
              decoration: isDone ? TextDecoration.lineThrough : null,
              decorationColor: AppColors.ink500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 13, color: AppColors.ink500),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd').format(task.deadline),
                    style: const TextStyle(fontSize: 11, color: AppColors.ink500),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (canGoBack)
                    GestureDetector(
                      onTap: onGoBack,
                      child: Container(
                        width: 26,
                        height: 26,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.line),
                          color: Colors.white,
                        ),
                        child: const Icon(Icons.arrow_back_rounded, size: 14, color: AppColors.ink500),
                      ),
                    ),
                  if (!isDone)
                    GestureDetector(
                      onTap: onAdvance,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.line),
                          color: Colors.white,
                        ),
                        child: const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.teal700),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Members tab ───────────────────────────────────────────────────────────────
class _MembersTab extends ConsumerWidget {
  final int projectId;
  final int ownerId;
  const _MembersTab({required this.projectId, required this.ownerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(projectMembersProvider(projectId));
    final currentUserAsync = ref.watch(userProfileProvider);

    return membersAsync.when(
      data: (members) {
        final currentUserId = currentUserAsync.value?.id;
        final isOwner = ownerId == currentUserId;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Members (${members.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink900,
                  ),
                ),
                if (isOwner)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _AddBtn(
                        label: 'Invite',
                        onTap: () =>
                            _showInviteSheet(context, projectId, ref, members),
                      ),
                      const SizedBox(width: 8),
                      _AddBtn(
                        label: 'Manage',
                        onTap: () =>
                            context.push('/project/$projectId/manage-members'),
                      ),
                    ],
                  )
                else
                  TextButton.icon(
                    onPressed: currentUserId == null ? null : () => _showLeaveConfirmation(context, ref, projectId),
                    icon: const Icon(Icons.exit_to_app_rounded, size: 16, color: Colors.red),
                    label: const Text('Leave', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            ...members.map(
              (m) => _MemberCard(
                member: m,
                isSelf: m.userId == currentUserId,
                isOwner: isOwner,
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final ProjectMemberResponse member;
  final bool isSelf;
  final bool isOwner;
  const _MemberCard({
    required this.member,
    required this.isSelf,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        children: [
          UserAvatar(
            name: '${member.firstName} ${member.lastName}',
            size: 42,
            status: 'online',
            imageUrl: ApiClient.buildImageUrl(member.profilePictureUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${member.firstName} ${member.lastName}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink900,
                      ),
                    ),
                    if (isSelf)
                      const Text(
                        ' (you)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.ink400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                Text(
                  member.memberRole.name,
                  style: const TextStyle(fontSize: 11, color: AppColors.ink500),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.bgAlt,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.line),
            ),
            child: Text(
              member.memberRole.name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.ink700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chat tab ──────────────────────────────────────────────────────────────────
class _ChatTab extends ConsumerStatefulWidget {
  final int projectId;
  const _ChatTab({required this.projectId});

  @override
  ConsumerState<_ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends ConsumerState<_ChatTab> {
  final _ctrl = TextEditingController();
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
    ref.read(chatProvider(widget.projectId).notifier).sendMessage(text);
    _ctrl.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatProvider(widget.projectId));
    final currentUserAsync = ref.watch(userProfileProvider);

    return Column(
      children: [
        Expanded(
          child: messagesAsync.when(
            data: (messages) => ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final msg = messages[i];
                final isMe = msg.senderId == currentUserAsync.value?.id;
                return GestureDetector(
                  onLongPress: isMe
                      ? () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Text(
                                'Delete message?',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                              content: const Text(
                                'This will permanently remove your message.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Color(0xFFDC2626)),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            ref
                                .read(chatProvider(widget.projectId).notifier)
                                .deleteMessage(msg.id);
                          }
                        }
                      : null,
                  child: _Bubble(
                    text: msg.content,
                    time: DateFormat('HH:mm').format(msg.sentAt),
                    isMe: isMe,
                    senderName: msg.senderName,
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),

        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          decoration: BoxDecoration(
            color: AppColors.bg.withValues(alpha: 0.95),
            border: const Border(top: BorderSide(color: AppColors.lineSoft)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: TextField(
                    controller: _ctrl,
                    onSubmitted: (_) => _send(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.ink900,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Message project',
                      hintStyle: TextStyle(
                        color: AppColors.ink400,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _send,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.teal700.withValues(alpha: 0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text, time, senderName;
  final bool isMe;
  const _Bubble({
    required this.text,
    required this.time,
    required this.senderName,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            UserAvatar(name: senderName, size: 28),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 2),
                  child: Text(
                    senderName,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink500,
                    ),
                  ),
                ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.teal700 : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isMe ? 18 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 18),
                  ),
                  border: isMe ? null : Border.all(color: AppColors.lineSoft),
                  boxShadow: AppTheme.shadowSm,
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    color: isMe ? Colors.white : AppColors.ink900,
                    height: 1.4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3, left: 12, right: 12),
                child: Text(
                  time,
                  style: const TextStyle(fontSize: 9, color: AppColors.ink400),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.teal50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.teal100),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.teal700,
        ),
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
          borderRadius: BorderRadius.circular(12),
          gradient: AppTheme.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.teal700.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedToggle extends StatelessWidget {
  final String value;
  final List<(String, String)> options;
  final ValueChanged<String> onChange;
  const _SegmentedToggle({
    required this.value,
    required this.options,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.bgAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: options.map((o) {
          final sel = value == o.$1;
          return GestureDetector(
            onTap: () => onChange(o.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: sel ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: sel
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 3,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                o.$2,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: sel ? AppColors.ink900 : AppColors.ink500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

void _showLeaveConfirmation(BuildContext context, WidgetRef ref, int projectId) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Leave Project', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink900)),
      content: const Text('Are you sure you want to leave this project?', style: TextStyle(color: AppColors.ink700, height: 1.5)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel', style: TextStyle(color: AppColors.ink500, fontWeight: FontWeight.w600)),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(ctx);
            await ref.read(myProjectsProvider.notifier).leaveProject(projectId);
            if (context.mounted) context.pop();
          },
          child: const Text('Leave', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );
}

void _showInviteSheet(
  BuildContext context,
  int projectId,
  WidgetRef ref,
  List<ProjectMemberResponse> existingMembers,
) {
  final searchCtrl = TextEditingController();
  final Set<int> existingMemberIds = existingMembers
      .map((m) => m.userId)
      .toSet();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _InviteSheetContent(
      searchCtrl: searchCtrl,
      projectId: projectId,
      ref: ref,
      existingMemberIds: existingMemberIds,
    ),
  );
}

class _InviteSheetContent extends StatefulWidget {
  final TextEditingController searchCtrl;
  final int projectId;
  final WidgetRef ref;
  final Set<int> existingMemberIds;

  const _InviteSheetContent({
    required this.searchCtrl,
    required this.projectId,
    required this.ref,
    required this.existingMemberIds,
  });

  @override
  State<_InviteSheetContent> createState() => _InviteSheetContentState();
}

class _InviteSheetContentState extends State<_InviteSheetContent> {
  List<SearchUserResult> _results = [];
  bool _searching = false;
  Timer? _debounce;
  String? _error;

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _searching = false;
        _error = null;
      });
      return;
    }
    setState(() => _searching = true);
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        final results = await SearchService().searchUsersByName(query.trim());
        if (!mounted) return;
        setState(() {
          _results = results
              .where((u) => !widget.existingMemberIds.contains(u.id))
              .toList();
          _searching = false;
          _error = null;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _results = [];
          _searching = false;
          _error = e.toString();
        });
      }
    });
  }

  Future<void> _inviteUser(SearchUserResult user) async {
    try {
      await widget.ref
          .read(projectJoinRequestsProvider(widget.projectId).notifier)
          .sendInvite(user.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invitation sent to ${user.firstName} ${user.lastName}',
          ),
          backgroundColor: AppColors.teal700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      setState(() => _results.removeWhere((u) => u.id == user.id));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to invite: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Invite Member',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink900,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.ink500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Search users by name to invite them to this project.',
              style: TextStyle(fontSize: 12, color: AppColors.ink500),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgAlt,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.line),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: AppColors.ink400,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: widget.searchCtrl,
                      onChanged: _onSearchChanged,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.ink900,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search by name...',
                        hintStyle: TextStyle(
                          color: AppColors.ink400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (_searching)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else if (_error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _error!,
                    style: const TextStyle(fontSize: 13, color: Colors.red),
                  ),
                ),
              )
            else if (widget.searchCtrl.text.trim().isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Type a name to search',
                    style: TextStyle(fontSize: 13, color: AppColors.ink400),
                  ),
                ),
              )
            else if (_results.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No users found',
                    style: TextStyle(fontSize: 13, color: AppColors.ink400),
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _results.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: AppColors.lineSoft),
                  itemBuilder: (_, i) {
                    final user = _results[i];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: UserAvatar(
                        name: '${user.firstName} ${user.lastName}',
                        size: 40,
                        imageUrl: ApiClient.buildImageUrl(
                          user.profilePictureUrl,
                        ),
                      ),
                      title: Text(
                        '${user.firstName} ${user.lastName}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink900,
                        ),
                      ),
                      subtitle: Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.ink500,
                        ),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: AppTheme.primaryGradient,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => _inviteUser(user),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              child: Text(
                                'Invite',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
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
}

class _SheetField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  const _SheetField({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.ink500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgAlt,
            borderRadius: BorderRadius.circular(12),
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _OptionTile({
    required this.icon,
    required this.label,
    this.color = AppColors.ink900,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
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
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Icon(icon, size: 20, color: AppColors.ink700),
      ),
    );
  }
}
