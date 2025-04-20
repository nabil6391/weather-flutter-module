import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({
    Key? key,
    required this.navigationShell,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body is now the navigationShell, which manages the indexed stack for us
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        // Use the goBranch method to navigate to the different branches
        onTap: (index) => _onItemTapped(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    // Only navigate if the user is selecting a different tab
    if (index != navigationShell.currentIndex) {
      navigationShell.goBranch(
        index,
        // This prevents a new history entry from being added for each tab change
        initialLocation: index == 0,
      );
    }
  }
}
