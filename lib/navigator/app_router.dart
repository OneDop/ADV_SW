// lib/app_router.dart
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
    // Login route
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // Signup route
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    // Project Info route (standalone or can be nested)
    GoRoute(
      path: '/project-info',
      builder: (context, state) => const ProjectInfoScreen(),
    ),
    // StatefulShellRoute creates the persistent bottom bar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return RootScreen(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Tab 2: Projects
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/projects-tab',
              builder: (context, state) => const ProjectsListScreen(),
            ),
          ],
        ),
        // Tab 3: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
        // Tab 4: Notifications (Updates)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const NotificationsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);