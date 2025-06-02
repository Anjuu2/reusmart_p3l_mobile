import 'package:flutter/material.dart';
import 'package:reusmart_mobile/View/Pembeli_profile.dart';

class PembeliDashboard extends StatefulWidget {
  final String namaPembeli;
  const PembeliDashboard({Key? key, required this.namaPembeli}) : super(key: key);

  @override
  _PembeliDashboardState createState() => _PembeliDashboardState();
}

class _PembeliDashboardState extends State<PembeliDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      Center(child: Text('Ini halaman dashboard pembeli')),
      PembeliProfile(namaPembeli: widget.namaPembeli),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Selamat datang, ${widget.namaPembeli}')),
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
