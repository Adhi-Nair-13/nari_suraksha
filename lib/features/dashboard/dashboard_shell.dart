import 'package:flutter/material.dart';
import '../sos/sos_screen.dart';
import '../emergency_contacts/contacts_screen.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({Key? key}) : super(key: key);

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const SosScreen(),
    const ContactsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.gpp_maybe_outlined),
            selectedIcon: Icon(Icons.gpp_maybe, color: Colors.deepPurple),
            label: 'SOS Shield',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people, color: Colors.deepPurple),
            label: 'Guardians',
          ),
        ],
      ),
    );
  }
}