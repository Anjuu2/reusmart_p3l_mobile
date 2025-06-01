import 'package:flutter/material.dart';

class KurirProfile extends StatelessWidget {
  final String namaKurir;

  const KurirProfile({Key? key, required this.namaKurir}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Kurir'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Nama: $namaKurir', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            // Tambahkan info profil lain di sini
            Text('Email: kurir@example.com'),
            Text('No. Telepon: 08123456789'),
          ],
        ),
      ),
    );
  }
}
