import 'package:flutter/material.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String bio;
  final String status; // available | busy | offline
  final String experience;
  final List<String> skills;
  final List<String> pastProjects;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.status,
    required this.experience,
    required this.skills,
    required this.pastProjects,
  });

  String get firstName => name.split(' ').first;
}

class ProjectMember {
  final String id;
  final String name;
  final String role;
  final String status;

  const ProjectMember({
    required this.id,
    required this.name,
    required this.role,
    required this.status,
  });
}

class TaskCounts {
  final int todo;
  final int progress;
  final int done;

  const TaskCounts({required this.todo, required this.progress, required this.done});

  int get total => todo + progress + done;
}

class AppProject {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color iconBg;
  final double progress;
  final String status;
  final List<String> tags;
  final String ownerId;
  final List<ProjectMember> members;
  final TaskCounts taskCounts;

  const AppProject({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.iconBg,
    required this.progress,
    required this.status,
    required this.tags,
    required this.ownerId,
    required this.members,
    required this.taskCounts,
  });
}

class AppTask {
  final String id;
  final String title;
  final String category;
  String status; // todo | progress | done
  final String due;
  final String? priority;
  final List<String> assignees;

  AppTask({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.due,
    this.priority,
    required this.assignees,
  });
}

class AppMessage {
  final String id;
  final String userId;
  final String text;
  final String time;

  const AppMessage({
    required this.id,
    required this.userId,
    required this.text,
    required this.time,
  });
}

class DiscoverUser {
  final String id;
  final String name;
  final String role;
  final List<String> skills;
  final String status;

  const DiscoverUser({
    required this.id,
    required this.name,
    required this.role,
    required this.skills,
    required this.status,
  });
}

class AppNotification {
  final String id;
  final String type;
  final String title;
  final String body;
  final String meta;
  final IconData icon;
  final bool actionable;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.meta,
    required this.icon,
    this.actionable = false,
  });
}

// ── Seed data ──────────────────────────────────────────────────────────────────

class SeedData {
  static const currentUser = AppUser(
    id: 'u1',
    name: 'Alex Rivera',
    email: 'alex.rivera@quietengine.io',
    bio: 'Product designer focused on collaborative tools. Probably in a meeting.',
    status: 'available',
    experience: 'Senior · 6 yrs',
    skills: ['Product Design', 'Flutter', 'Design Systems', 'User Research', 'Figma'],
    pastProjects: ['Aris Brand Identity', 'Quantum Architecture v1', 'Helio Mobile'],
  );

  static final List<AppProject> projects = [
    AppProject(
      id: 'p1',
      name: 'Quantum Architecture',
      description: 'Refactoring the core engine for sub-millisecond latency and implementing the new collaborative canvas protocol.',
      icon: Icons.architecture,
      iconBg: const Color(0xFFD0E6F3),
      progress: 0.68,
      status: 'In Progress',
      tags: ['Engineering', 'V2 Launch'],
      ownerId: 'u1',
      members: const [
        ProjectMember(id: 'u1', name: 'Alex Rivera', role: 'Owner', status: 'available'),
        ProjectMember(id: 'u2', name: 'Mira Chen',   role: 'Editor', status: 'available'),
        ProjectMember(id: 'u3', name: 'Jonas Webb',  role: 'Editor', status: 'busy'),
        ProjectMember(id: 'u4', name: 'Priya Shah',  role: 'Viewer', status: 'offline'),
        ProjectMember(id: 'u5', name: 'Léo Martin',  role: 'Editor', status: 'busy'),
      ],
      taskCounts: TaskCounts(todo: 12, progress: 3, done: 28),
    ),
    AppProject(
      id: 'p2',
      name: 'Aris Brand Identity',
      description: 'Visual system, type pairings and motion guidelines for the Aris rebrand.',
      icon: Icons.palette,
      iconBg: const Color(0xFFFFE3D1),
      progress: 0.65,
      status: 'In Progress',
      tags: ['Design'],
      ownerId: 'u2',
      members: const [
        ProjectMember(id: 'u2', name: 'Mira Chen',   role: 'Owner', status: 'available'),
        ProjectMember(id: 'u1', name: 'Alex Rivera', role: 'Editor', status: 'available'),
        ProjectMember(id: 'u6', name: 'Sara Holm',   role: 'Editor', status: 'available'),
      ],
      taskCounts: TaskCounts(todo: 4, progress: 6, done: 17),
    ),
    AppProject(
      id: 'p3',
      name: 'E-Commerce Portal',
      description: 'Customer-facing storefront rebuild on the new platform.',
      icon: Icons.storefront,
      iconBg: const Color(0xFFD6EDDE),
      progress: 0.12,
      status: 'Planning',
      tags: ['Web'],
      ownerId: 'u3',
      members: const [
        ProjectMember(id: 'u3', name: 'Jonas Webb',  role: 'Owner', status: 'busy'),
        ProjectMember(id: 'u1', name: 'Alex Rivera', role: 'Editor', status: 'available'),
      ],
      taskCounts: TaskCounts(todo: 18, progress: 1, done: 2),
    ),
    AppProject(
      id: 'p4',
      name: 'Helio Mobile',
      description: 'iOS + Android app for the Helio product.',
      icon: Icons.smartphone,
      iconBg: const Color(0xFFE5D6F3),
      progress: 0.85,
      status: 'In Progress',
      tags: ['Mobile', 'Flutter'],
      ownerId: 'u1',
      members: const [
        ProjectMember(id: 'u1', name: 'Alex Rivera', role: 'Owner', status: 'available'),
        ProjectMember(id: 'u4', name: 'Priya Shah',  role: 'Editor', status: 'offline'),
      ],
      taskCounts: TaskCounts(todo: 2, progress: 3, done: 24),
    ),
    AppProject(
      id: 'p5',
      name: 'Marketing Site',
      description: 'Static marketing site, blog and pricing page.',
      icon: Icons.language,
      iconBg: const Color(0xFFD0E6F3),
      progress: 1.0,
      status: 'Completed',
      tags: ['Web'],
      ownerId: 'u5',
      members: const [
        ProjectMember(id: 'u5', name: 'Léo Martin', role: 'Owner', status: 'busy'),
      ],
      taskCounts: TaskCounts(todo: 0, progress: 0, done: 31),
    ),
  ];

  static final Map<String, List<AppTask>> tasks = {
    'p1': [
      AppTask(id: 't1', title: 'Define WebSocket heartbeat intervals',        category: 'Infrastructure', status: 'todo',     due: 'Oct 12', assignees: ['u2']),
      AppTask(id: 't2', title: 'Finalize dark mode elevation tokens',          category: 'Design System',  status: 'todo',     due: 'Oct 14', assignees: ['u2', 'u6']),
      AppTask(id: 't3', title: 'Spec activity timeline component',             category: 'Design System',  status: 'todo',     due: 'Oct 18', assignees: ['u1']),
      AppTask(id: 't4', title: 'Implement end-to-end encryption for messages', category: 'Critical Path',  status: 'progress', due: 'Tomorrow', priority: 'High', assignees: ['u3']),
      AppTask(id: 't5', title: 'Migrate auth provider to v3 SDK',              category: 'Infrastructure', status: 'progress', due: 'Oct 16', assignees: ['u3', 'u1']),
      AppTask(id: 't6', title: 'Wire up presence indicators',                  category: 'Frontend',       status: 'progress', due: 'Oct 17', assignees: ['u2']),
      AppTask(id: 't7', title: 'Asset pack export for marketing',              category: 'Branding',       status: 'done',     due: 'Oct 04', assignees: ['u2']),
      AppTask(id: 't8', title: 'Onboarding tour copy review',                  category: 'Content',        status: 'done',     due: 'Oct 02', assignees: ['u6']),
    ],
  };

  static final Map<String, List<AppMessage>> messages = {
    'p1': [
      const AppMessage(id: 'm1', userId: 'u2', text: 'Pushed the new canvas protocol draft to the design doc. Comments welcome.', time: '9:42 AM'),
      const AppMessage(id: 'm2', userId: 'u1', text: 'Reading now. The merge resolution flow is much cleaner!', time: '9:46 AM'),
      const AppMessage(id: 'm3', userId: 'u3', text: 'I can take WebSocket heartbeats. Anything blocking?', time: '10:02 AM'),
      const AppMessage(id: 'm4', userId: 'u1', text: 'Nope — go for it. I unblocked the staging env.', time: '10:04 AM'),
      const AppMessage(id: 'm5', userId: 'u5', text: 'Standup in 5.', time: '10:25 AM'),
    ],
  };

  static const List<AppNotification> notifications = [
    AppNotification(id: 'n1', type: 'task',     title: 'Task assigned',   body: '"Spec activity timeline component" was assigned to you',     meta: 'Quantum Architecture · 4m ago',  icon: Icons.task_alt),
    AppNotification(id: 'n2', type: 'message',  title: 'New message',     body: 'Mira: Pushed the new canvas protocol draft…',                meta: 'Quantum Architecture · 18m ago', icon: Icons.chat_bubble_outline),
    AppNotification(id: 'n3', type: 'deadline', title: 'Deadline soon',   body: '"End-to-end encryption" is due tomorrow',                    meta: 'Quantum Architecture · 1h ago',  icon: Icons.schedule),
    AppNotification(id: 'n4', type: 'invite',   title: 'Join request',    body: 'Tomás Reyes asked to join Aris Brand Identity',              meta: '3h ago',    icon: Icons.group_add, actionable: true),
    AppNotification(id: 'n5', type: 'invite',   title: 'Invitation',      body: 'You were invited to "Helio Watch v2"',                       meta: 'Yesterday', icon: Icons.mail_outline, actionable: true),
    AppNotification(id: 'n6', type: 'task',     title: 'Task completed',  body: 'Priya marked "Asset pack export" as done',                   meta: 'Yesterday', icon: Icons.check_circle_outline),
  ];

  static const List<DiscoverUser> discoverUsers = [
    DiscoverUser(id: 'u7',  name: 'Tomás Reyes',   role: 'Mobile Engineer',     skills: ['Flutter', 'iOS', 'Animations'],        status: 'available'),
    DiscoverUser(id: 'u8',  name: 'Naomi Park',    role: 'Backend Engineer',    skills: ['Spring Boot', 'PostgreSQL', 'Kafka'],  status: 'available'),
    DiscoverUser(id: 'u9',  name: 'Diego Romano',  role: 'Product Designer',    skills: ['Figma', 'Design Systems'],             status: 'busy'),
    DiscoverUser(id: 'u10', name: 'Hana Yamada',   role: 'Engineering Manager', skills: ['Agile', 'Mentorship'],                 status: 'available'),
    DiscoverUser(id: 'u11', name: 'Ravi Iyer',     role: 'Data Scientist',      skills: ['Python', 'ML', 'SQL'],                 status: 'offline'),
    DiscoverUser(id: 'u12', name: 'Sofia Klein',   role: 'Frontend Engineer',   skills: ['React', 'TypeScript'],                 status: 'available'),
  ];
}
