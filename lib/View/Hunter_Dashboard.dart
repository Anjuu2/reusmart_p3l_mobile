import 'package:flutter/material.dart';
import 'package:reusmart_mobile/View/Hunter_profile.dart';

class HunterDashboard extends StatelessWidget {
  final String namaHunter;
  const HunterDashboard({Key? key, required this.namaHunter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Nama hunter di dashboard: $namaHunter');
    return Scaffold(
      appBar: AppBar(title: Text('Selamat datang, $namaHunter')),
      body: Center(child: Text('Ini halaman dashboard hunter')),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HunterProfile(namaHunter: namaHunter)),
            );
          }
        },
      ),
    );
  }
}
