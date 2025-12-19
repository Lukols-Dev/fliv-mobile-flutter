import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithBottomNav extends StatelessWidget {
  const ScaffoldWithBottomNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
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
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onTap,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: Color(0xFF004F45),
                size: 28,
              ),
              selectedIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
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
              icon: Icon(
                Icons.route_outlined,
                color: Color(0xFF004F45),
                size: 28,
              ),
              selectedIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(0, 79, 69, 0.10),
                ),
                child: const Icon(
                  Icons.route_rounded,
                  color: Color(0xFF004F45),
                  size: 28,
                ),
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.description_outlined,
                color: Color(0xFF004F45),
                size: 28,
              ),
              selectedIcon: Container(
                padding: const EdgeInsets.all(8),
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
