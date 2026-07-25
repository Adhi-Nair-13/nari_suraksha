import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';
import 'package:nari_suraksha/features/home/screens/dashboard_screen.dart';
import 'package:nari_suraksha/features/sos/screens/sos_screen.dart';
import 'package:nari_suraksha/features/emergency_contacts/screens/contacts_screen.dart';
import 'package:nari_suraksha/features/profile/screens/profile_page.dart';

/// Home / Dashboard shell for authenticated users.
///
/// Acts as the bottom-navigation host. The first tab now hosts the
/// full [DashboardScreen]. The remaining tabs keep placeholder bodies
/// until their feature screens are implemented.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<_TabItem> _tabs = [
    _TabItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _TabItem(
      label: 'SOS',
      icon: Icons.gpp_maybe_outlined,
      activeIcon: Icons.gpp_maybe_rounded,
    ),
    _TabItem(
      label: 'Contacts',
      icon: Icons.people_outline,
      activeIcon: Icons.people_rounded,
    ),
    _TabItem(
      label: 'Profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          // Tab 0 — Dashboard
          DashboardScreen(),
          // Tab 1 — SOS screen
          SosScreen(),
          // Tab 2 — Emergency contacts
          ContactsScreen(),
          // Tab 3 — Profile
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: _tabs
            .map(
              (t) => NavigationDestination(
                icon: Icon(t.icon),
                selectedIcon: Icon(t.activeIcon, color: AppColors.primary),
                label: t.label,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

// ── Private helpers ──────────────────────────────────────────────────────────

class _TabItem {
  const _TabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}
