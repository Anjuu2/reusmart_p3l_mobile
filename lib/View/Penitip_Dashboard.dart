import 'package:flutter/material.dart';
import 'package:reusmart_mobile/View/Penitip_profile.dart';

class PenitipDashboard extends StatelessWidget {
  final String namaPenitip;
  final String apiToken;
  const PenitipDashboard({Key? key, required this.namaPenitip, required this.apiToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Nama penitip di dashboard: $namaPenitip');
    return Scaffold(
      appBar: AppBar(title: Text('Selamat datang, $namaPenitip')),
      body: Center(child: Text('Ini halaman dashboard penitip')),
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
              MaterialPageRoute(builder: (_) => PenitipProfile(namaPenitip: namaPenitip, apiToken: apiToken)),
            );
          }
        },
      ),
    );
  }
}
