// lib/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:advsw/screens/root/root.dart';
import 'package:advsw/screens/home/home.dart';
//import 'features/profile/profile_screen.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
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
        // Tab 2: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              //builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);