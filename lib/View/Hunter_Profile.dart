import 'package:flutter/material.dart';

class HunterProfile extends StatelessWidget {
  final String namaHunter;

  const HunterProfile({Key? key, required this.namaHunter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Hunter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Nama: $namaHunter', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            // Tambahkan info profil lain di sini
            Text('Email: hunter@example.com'),
            Text('No. Telepon: 08987654321'),
          ],
        ),
      ),
    );
  }
}
