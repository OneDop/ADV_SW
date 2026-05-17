import 'package:advsw/screens/admin/admin_screen.dart';
import 'package:advsw/screens/discover/discover_screen.dart';
import 'package:advsw/screens/myprojects/projects_list.dart';
import 'package:advsw/screens/mynotifications/notifications_screen.dart';
import 'package:advsw/screens/profile/edit_profile_screen.dart';
import 'package:advsw/screens/projectInfo/project_info.dart';
import 'package:advsw/screens/user_profile/user_profile_screen.dart';
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
      path: '/admin',
      builder: (context, state) => const AdminScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/user/:id',
      builder: (context, state) {
        final userId = state.pathParameters['id'] ?? '';
        return UserProfileScreen(userId: userId);
      },
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
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/discover', builder: (c, s) => const DiscoverScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/projects', builder: (c, s) => const ProjectsListScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/notifications', builder: (c, s) => const NotificationsScreen()),
        ]),
      ],
    ),
  ],
);
