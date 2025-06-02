import 'package:flutter/material.dart';

class HunterProfile extends StatelessWidget {
  final String namaHunter;

  const HunterProfile({Key? key, required this.namaHunter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Hunter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: $namaHunter', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Email: hunter@example.com'),
            const Text('No. Telepon: 08987654321'),
          ],
        ),
      ),
    );
  }
}
