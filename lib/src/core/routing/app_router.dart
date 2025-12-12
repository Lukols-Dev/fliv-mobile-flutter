import 'package:go_router/go_router.dart';

import 'package:mobile/src/features/auth/presentation/screens/auth_start/auth_start_screen.dart';

import 'route_not_found_screen.dart';

enum AppRoute { authStart }

extension AppRouteX on AppRoute {
  String get path => switch (this) {
    AppRoute.authStart => '/auth',
  };
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoute.authStart.path,
  routes: [
    GoRoute(
      path: AppRoute.authStart.path,
      builder: (context, state) => const AuthStartScreen(),
    ),
  ],
  errorBuilder: (context, state) => const RouteNotFoundScreen(),
);
