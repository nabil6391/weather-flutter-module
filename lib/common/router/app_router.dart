import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_profile_app/features/app_shell.dart';
import 'package:weather_profile_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:weather_profile_app/features/user_profile/presentation/profile_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  // Create branch navigator keys - one for each tab
  static final _dashboardNavigatorKey = GlobalKey<NavigatorState>();
  static final _profileNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    debugLogDiagnostics: true,
    routes: [
      // Use StatefulShellRoute instead of ShellRoute
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Return AppShell with the NavigationShell
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard branch
          StatefulShellBranch(
            navigatorKey: _dashboardNavigatorKey,
            routes: [
              GoRoute(
                path: '/dashboard',
                name: 'dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Profile branch
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
