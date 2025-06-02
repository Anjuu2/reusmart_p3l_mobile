import 'package:flutter/material.dart';

class KurirProfile extends StatelessWidget {
  final String namaKurir;

  const KurirProfile({Key? key, required this.namaKurir}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Kurir')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: $namaKurir', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Email: kurir@example.com'),
            const Text('No. Telepon: 08123456789'),
          ],
        ),
      ),
    );
  }
}
