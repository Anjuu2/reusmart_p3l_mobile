import 'package:flutter/material.dart';
import 'package:reusmart_mobile/View/Kurir_Profile.dart';

class KurirDashboard extends StatefulWidget {
  @override
  _KurirDashboardState createState() => _KurirDashboardState();
}

class _KurirDashboardState extends State<KurirDashboard> {
  int _currentIndex = 0;
  late String namaKurir;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    namaKurir = args != null ? args['nama_pegawai'] ?? 'User' : 'User';
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Center(child: Text('Ini halaman dashboard kurir')),
      KurirProfile(namaKurir: namaKurir),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Selamat datang, $namaKurir')),
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
