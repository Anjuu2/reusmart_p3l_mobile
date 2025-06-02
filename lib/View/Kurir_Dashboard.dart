import 'package:flutter/material.dart';
import 'package:reusmart_mobile/View/Kurir_profile.dart';

class KurirDashboard extends StatefulWidget {
  final String namaKurir;
  const KurirDashboard({Key? key, required this.namaKurir}) : super(key: key);

  @override
  _KurirDashboardState createState() => _KurirDashboardState();
}

class _KurirDashboardState extends State<KurirDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      Center(child: Text('Ini halaman dashboard kurir')),
      KurirProfile(namaKurir: widget.namaKurir),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Selamat datang, ${widget.namaKurir}')),
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
