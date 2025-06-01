import 'package:flutter/material.dart';

class PenitipProfile extends StatelessWidget {
  final String namaPenitip;

  const PenitipProfile({Key? key, required this.namaPenitip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Penitip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Nama: $namaPenitip', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            // Tambahkan info profil lain di sini
            Text('Email: penitip@example.com'),
            Text('Alamat: Jalan Contoh No.456'),
          ],
        ),
      ),
    );
  }
}
