import 'package:flutter/material.dart';
import 'package:hrsm/core/theme/colors/C.dart';
import 'package:hrsm/features/configerations/presentation/configrations_page/regions_configuration_page.dart';
import 'package:hrsm/features/dashboard/Presentation/dashboard_page/dashboard_page.dart';

class lol extends StatefulWidget {
  const lol({super.key});

  @override
  State<lol> createState() => _lolState();
}

class _lolState extends State<lol> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const RegionsConfigurationPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.primarybackgrond,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: C.orange1,
        unselectedItemColor: C.grey2,
        backgroundColor: C.primarybackgrond,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Regions',
          ),
        ],
      ),
    );
  }
}
