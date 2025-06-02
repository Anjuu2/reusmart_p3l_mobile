import 'package:flutter/material.dart';
import 'package:reusmart_mobile/View/Kurir_profile.dart';

class KurirDashboard extends StatelessWidget {
  final String namaKurir;
  const KurirDashboard({Key? key, required this.namaKurir}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Nama kurir di dashboard: $namaKurir');
    return Scaffold(
      appBar: AppBar(title: Text('Selamat datang, $namaKurir')),
      body: Center(child: Text('Ini halaman dashboard kurir')),
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
              MaterialPageRoute(builder: (_) => KurirProfile(namaKurir: namaKurir)),
            );
          }
        },
      ),
    );
  }
}
