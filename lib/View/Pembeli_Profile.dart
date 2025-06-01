import 'package:flutter/material.dart';

class PembeliProfile extends StatelessWidget {
  final String namaPembeli;

  const PembeliProfile({Key? key, required this.namaPembeli}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Pembeli'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Nama: $namaPembeli', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            // Tambahkan info profil lain di sini
            Text('Email: user@example.com'),
            Text('Alamat: Jalan Contoh No.123'),
          ],
        ),
      ),
    );
  }
}
