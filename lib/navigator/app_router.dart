import 'package:advsw/features/admin/admin_screen.dart';
import 'package:advsw/features/discovery/project_discovery_screen.dart';
import 'package:advsw/features/notifications/notification_screen.dart';
import 'package:advsw/features/profile_management/edit_profile_screen.dart';
import 'package:advsw/features/profile_management/portfolio_update_screen.dart';
import 'package:advsw/features/project_management/member_management_screen.dart';
import 'package:advsw/features/search/global_search_screen.dart';
import 'package:advsw/screens/auth/forgot_password_screen.dart';
import 'package:advsw/screens/myprojects/projects_list.dart';
import 'package:advsw/screens/projectInfo/project_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/screens/root/root.dart';
import 'package:advsw/screens/home/home.dart';
import 'package:advsw/screens/auth/login_screen.dart';
import 'package:advsw/screens/auth/signup_screen.dart';
import 'package:advsw/screens/profile/profile.dart';
import 'package:advsw/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      final isLoggedIn = await authService.isLoggedIn();
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/forgot-password';

      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }
      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }
      return null;
    },
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
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
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
        path: '/portfolio-update',
        name: 'portfolio-update',
        builder: (context, state) => const PortfolioUpdateScreen(),
      ),
      GoRoute(
        path: '/my-projects',
        name: 'my-projects',
        builder: (context, state) => const ProjectsListScreen(),
      ),
      GoRoute(
        path: '/project/:id',
        builder: (context, state) {
          final projectId = state.pathParameters['id'] ?? '1';
          return ProjectInfoScreen(projectId: projectId);
        },
      ),
      GoRoute(
        path: '/project/:id/manage-members',
        name: 'member-management',
        builder: (context, state) {
          final projectId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return MemberManagementScreen(projectId: projectId);
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
            GoRoute(path: '/discover', name: 'discover', builder: (c, s) => const ProjectDiscoveryScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/search', name: 'search', builder: (c, s) => const GlobalSearchScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/notifications', builder: (c, s) => const NotificationScreen()),
          ]),
        ],
      ),
    ],
  );
});
