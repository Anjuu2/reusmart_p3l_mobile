import 'package:flutter/material.dart';

class PembeliProfile extends StatelessWidget {
  final String namaPembeli;

  const PembeliProfile({Key? key, required this.namaPembeli}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pembeli')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: $namaPembeli', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Email: user@example.com'),
            const Text('Alamat: Jalan Contoh No.123'),
          ],
        ),
      ),
    );
  }
}
