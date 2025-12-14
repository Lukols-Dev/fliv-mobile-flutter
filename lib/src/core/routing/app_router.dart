import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/src/features/auth/presentation/screens/auth_start/auth_start_screen.dart';
import 'package:mobile/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:mobile/src/features/auth/presentation/screens/register/register_screen.dart';
import 'package:mobile/src/features/auth/presentation/screens/forgot_password/forgot_password_screen.dart';

import 'package:mobile/src/features/home/presentation/screens/home_screen.dart';

import 'route_not_found_screen.dart';
import 'scaffold_with_bottom_nav.dart';

enum AppRoute {
  authStart,
  login,
  register,
  forgotPassword,

  home,
  orders,
  account,
}

extension AppRouteX on AppRoute {
  String get path => switch (this) {
    AppRoute.authStart => '/auth',
    AppRoute.login => '/auth/login',
    AppRoute.register => '/auth/register',
    AppRoute.forgotPassword => '/auth/forgot-password',

    AppRoute.home => '/home',
    AppRoute.orders => '/orders',
    AppRoute.account => '/account',
  };
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
// final _ordersNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'orders');
// final _accountNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'account');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoute.authStart.path,

  routes: [
    // AUTH (poza bottom nav)
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

    // APP (bottom nav z zachowaniem stanu tabów)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithBottomNav(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoute.home.path,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // StatefulShellBranch(
        //   navigatorKey: _ordersNavigatorKey,
        //   routes: [
        //     GoRoute(
        //       path: AppRoute.orders.path,
        //       builder: (context, state) => const OrdersScreen(),
        //     ),
        //   ],
        // ),
        // StatefulShellBranch(
        //   navigatorKey: _accountNavigatorKey,
        //   routes: [
        //     GoRoute(
        //       path: AppRoute.account.path,
        //       builder: (context, state) => const AccountScreen(),
        //     ),
        //   ],
        // ),
      ],
    ),
  ],

  errorBuilder: (context, state) => const RouteNotFoundScreen(),
);
