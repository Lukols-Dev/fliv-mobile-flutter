import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/src/core/routing/app_router.dart';

class ScaffoldWithBottomNav extends StatelessWidget {
  const ScaffoldWithBottomNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    // UI indexy: 0=home, 1=route(fullscreen), 2=documents
    if (index == 1) {
      // ROUTE = fullscreen mapa (poza bottom nav)
      context.push(AppRoute.route.path);
      return;
    }

    // Shell indexy: 0=home, 1=documents
    final shellIndex = index == 0 ? 0 : 1;

    navigationShell.goBranch(
      shellIndex,
      initialLocation: shellIndex == navigationShell.currentIndex,
    );
  }

  int _uiSelectedIndex() {
    // Shell currentIndex: 0=home, 1=documents
    // UI selectedIndex: 0=home, 2=documents (route nie jest shellem)
    return navigationShell.currentIndex == 0 ? 0 : 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          selectedIndex: _uiSelectedIndex(),
          onDestinationSelected: (index) => _onTap(context, index),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            NavigationDestination(
              icon: const Icon(
                Icons.home_outlined,
                color: Color(0xFF004F45),
                size: 28,
              ),
              selectedIcon: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(0, 79, 69, 0.10),
                ),
                child: const Icon(
                  Icons.home_outlined,
                  color: Color(0xFF004F45),
                  size: 28,
                ),
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Transform.rotate(
                angle: math.pi / 2,
                child: const Icon(
                  Icons.route_outlined,
                  color: Color(0xFF004F45),
                  size: 28,
                ),
              ),
              selectedIcon: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(0, 79, 69, 0.10),
                ),
                child: Transform.rotate(
                  angle: math.pi / 2,
                  child: const Icon(
                    Icons.route_rounded,
                    color: Color(0xFF004F45),
                    size: 28,
                  ),
                ),
              ),
              label: '',
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.description_outlined,
                color: Color(0xFF004F45),
                size: 28,
              ),
              selectedIcon: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(0, 79, 69, 0.10),
                ),
                child: const Icon(
                  Icons.description,
                  color: Color(0xFF004F45),
                  size: 28,
                ),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
