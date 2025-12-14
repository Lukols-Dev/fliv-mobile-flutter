import 'package:go_router/go_router.dart';

import 'package:mobile/src/features/auth/presentation/screens/auth_start/auth_start_screen.dart';
import 'package:mobile/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:mobile/src/features/auth/presentation/screens/register/register_screen.dart';
import 'package:mobile/src/features/auth/presentation/screens/forgot_password/forgot_password_screen.dart';

import 'route_not_found_screen.dart';

enum AppRoute { authStart, login, register, forgotPassword }

extension AppRouteX on AppRoute {
  String get path => switch (this) {
    AppRoute.authStart => '/auth',
    AppRoute.login => '/auth/login',
    AppRoute.register => '/auth/register',
    AppRoute.forgotPassword => '/auth/forgot-password',
  };
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoute.authStart.path,
  routes: [
    GoRoute(
      path: AppRoute.authStart.path,
      builder: (context, state) => const AuthStartScreen(),
    ),
    GoRoute(
      path: AppRoute.login.path,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoute.register.path,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoute.forgotPassword.path,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
  ],
  errorBuilder: (context, state) => const RouteNotFoundScreen(),
);
