import 'package:flutter/material.dart';
import 'package:reusmart_mobile/View/Hunter_Profile.dart';

class HunterDashboard extends StatefulWidget {
  @override
  _HunterDashboardState createState() => _HunterDashboardState();
}

class _HunterDashboardState extends State<HunterDashboard> {
  int _currentIndex = 0;
  late String namaHunter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    namaHunter = args != null ? args['nama_pegawai'] ?? 'User' : 'User';
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Center(child: Text('Ini halaman dashboard hunter')),
      HunterProfile(namaHunter: namaHunter),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Selamat datang, $namaHunter')),
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
