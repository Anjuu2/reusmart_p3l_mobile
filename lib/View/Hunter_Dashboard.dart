import 'package:flutter/material.dart';
import 'package:reusmart_mobile/View/Hunter_profile.dart';

class HunterDashboard extends StatefulWidget {
  final String namaHunter;
  const HunterDashboard({Key? key, required this.namaHunter}) : super(key: key);

  @override
  _HunterDashboardState createState() => _HunterDashboardState();
}

class _HunterDashboardState extends State<HunterDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      Center(child: Text('Ini halaman dashboard hunter')),
      HunterProfile(namaHunter: widget.namaHunter),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Selamat datang, ${widget.namaHunter}')),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
