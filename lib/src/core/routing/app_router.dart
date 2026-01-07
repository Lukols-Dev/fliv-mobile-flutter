import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/src/features/auth/presentation/screens/auth_start/auth_start_screen.dart';
import 'package:mobile/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:mobile/src/features/auth/presentation/screens/register/register_screen.dart';
import 'package:mobile/src/features/auth/presentation/screens/forgot_password/forgot_password_screen.dart';

import 'package:mobile/src/features/home/presentation/screens/home_screen.dart';
import 'package:mobile/src/features/account/presentation/screens/account_screen.dart';
import 'package:mobile/src/features/account/presentation/screens/your_data_screen.dart';
import 'package:mobile/src/features/account/presentation/screens/driver_data_screen.dart';
import 'package:mobile/src/features/orders/presentation/screens/order_details_screen.dart';
import 'package:mobile/src/features/documents/presentation/screens/documents_screen.dart';
import 'package:mobile/src/features/documents/presentation/screens/add_document_screen.dart';
import 'package:mobile/src/features/route/presentation/screens/route_screen.dart';

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
  yourData,
  driverData,
  orderDetails,
  route,
  documents,
  addDocument,
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
    AppRoute.yourData => '/account/your-data',
    AppRoute.driverData => '/account/driver-data',
    AppRoute.orderDetails => '/orders/:orderId',
    AppRoute.route => '/route',
    AppRoute.documents => '/documents',
    AppRoute.addDocument => '/documents/add',
  };
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _routeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'route');
final _documentsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'documents',
);
// final _ordersNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'orders');

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
    GoRoute(
      path: AppRoute.orderDetails.path,
      builder: (context, state) {
        final orderId = state.pathParameters['orderId'] ?? '';
        return OrderDetailsScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/documents/add',
      builder: (context, state) {
        final orderId = state.uri.queryParameters['orderId'] ?? '';
        return AddDocumentScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: AppRoute.account.path,
      builder: (context, state) => const AccountScreen(),
      routes: [
        GoRoute(
          path: 'your-data',
          builder: (context, state) => const YourDataScreen(),
        ),
        GoRoute(
          path: 'driver-data',
          builder: (context, state) => const DriverDataScreen(),
        ),
      ],
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
        StatefulShellBranch(
          navigatorKey: _routeNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoute.route.path,
              builder: (context, state) => const RouteScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _documentsNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoute.documents.path,
              builder: (context, state) {
                final orderId = state.uri.queryParameters['orderId'];
                final ztNumber = state.uri.queryParameters['ztNumber'];
                return DocumentsScreen(orderId: orderId, ztNumber: ztNumber);
              },
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
