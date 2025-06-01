import 'package:flutter/material.dart';
import 'package:reusmart_mobile/View/Pembeli_Profile.dart'; // Import halaman profil pembeli

class PembeliDashboard extends StatefulWidget {
  @override
  _PembeliDashboardState createState() => _PembeliDashboardState();
}

class _PembeliDashboardState extends State<PembeliDashboard> {
  int _currentIndex = 0;
  late String namaPembeli;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    namaPembeli = args != null ? args['nama_pembeli'] ?? 'User' : 'User';
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Center(child: Text('Ini halaman dashboard pembeli')),
      PembeliProfile(namaPembeli: namaPembeli),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Selamat datang, $namaPembeli')),
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
