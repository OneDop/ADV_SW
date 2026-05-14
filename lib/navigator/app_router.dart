import 'package:advsw/screens/discover/discover_screen.dart';
import 'package:advsw/screens/myprojects/projects_list.dart';
import 'package:advsw/screens/mynotifications/notifications_screen.dart';
import 'package:advsw/screens/projectInfo/project_info.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/screens/root/root.dart';
import 'package:advsw/screens/home/home.dart';
import 'package:advsw/screens/auth/login_screen.dart';
import 'package:advsw/screens/auth/signup_screen.dart';
import 'package:advsw/screens/profile/profile.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/project/:id',
      builder: (context, state) {
        final projectId = state.pathParameters['id'] ?? 'p1';
        return ProjectInfoScreen(projectId: projectId);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          RootScreen(navigationShell: navigationShell),
      branches: [
        // 0: Home
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
        ]),
        // 1: Discover
        StatefulShellBranch(routes: [
          GoRoute(path: '/discover', builder: (c, s) => const DiscoverScreen()),
        ]),
        // 2: Projects
        StatefulShellBranch(routes: [
          GoRoute(path: '/projects', builder: (c, s) => const ProjectsListScreen()),
        ]),
        // 3: Profile
        StatefulShellBranch(routes: [
          GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
        ]),
        // 4: Notifications
        StatefulShellBranch(routes: [
          GoRoute(path: '/notifications', builder: (c, s) => const NotificationsScreen()),
        ]),
      ],
    ),
  ],
);
