import 'package:flutter/material.dart';
import 'package:reusmart_mobile/View/Merchandise.dart';
import 'package:reusmart_mobile/View/Pembeli_profile.dart';

class PembeliDashboard extends StatelessWidget {
  final String namaPembeli;
  const PembeliDashboard({Key? key, required this.namaPembeli}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Nama pembeli di dashboard: $namaPembeli');
    return Scaffold(
      appBar: AppBar(title: Text('Selamat datang, $namaPembeli')),
      body: Center(child: Text('Ini halaman dashboard pembeli')),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Merchandise',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PembeliProfile(namaPembeli: namaPembeli)),
            );
          } else if(index == 1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MerchandisePage(namaPembeli: namaPembeli)),
            );
          }
        },
      ),
    );
  }
}
