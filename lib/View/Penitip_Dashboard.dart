import 'package:flutter/material.dart';
import 'package:reusmart_mobile/View/Penitip_Profile.dart';

class PenitipDashboard extends StatefulWidget {
  @override
  _PenitipDashboardState createState() => _PenitipDashboardState();
}

class _PenitipDashboardState extends State<PenitipDashboard> {
  int _currentIndex = 0;
  late String namaPenitip;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    namaPenitip = args != null ? args['nama_penitip'] ?? 'User' : 'User';
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Center(child: Text('Ini halaman dashboard penitip')),
      PenitipProfile(namaPenitip: namaPenitip),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Selamat datang, $namaPenitip')),
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
