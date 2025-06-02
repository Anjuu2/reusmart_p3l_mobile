import 'package:flutter/material.dart';
import 'package:reusmart_mobile/View/Penitip_profile.dart';

class PenitipDashboard extends StatefulWidget {
  final String namaPenitip;
  const PenitipDashboard({Key? key, required this.namaPenitip}) : super(key: key);

  @override
  _PenitipDashboardState createState() => _PenitipDashboardState();
}

class _PenitipDashboardState extends State<PenitipDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      Center(child: Text('Ini halaman dashboard penitip')),
      PenitipProfile(namaPenitip: widget.namaPenitip),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Selamat datang, ${widget.namaPenitip}')),
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
