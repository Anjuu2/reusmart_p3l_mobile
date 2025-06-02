import 'package:flutter/material.dart';

class PenitipProfile extends StatelessWidget {
  final String namaPenitip;

  const PenitipProfile({Key? key, required this.namaPenitip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Penitip')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: $namaPenitip', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Email: penitip@example.com'),
            const Text('Alamat: Jalan Contoh No.456'),
          ],
        ),
      ),
    );
  }
}
