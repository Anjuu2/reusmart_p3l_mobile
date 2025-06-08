import 'package:flutter/material.dart';
import 'package:reusmart_mobile/client/LoginClient.dart';

class PenitipProfile extends StatelessWidget {
  final String namaPenitip;
  final String apiToken;

  const PenitipProfile({Key? key, required this.namaPenitip, required this.apiToken}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Penitip')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama: $namaPenitip',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Email: penitip@example.com'),
            const Text('Alamat: Jalan Contoh No.456'),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  LoginClient loginClient = LoginClient();
                  final result = await loginClient.logout(apiToken);  // Panggil fungsi logout dari loginClient.dart
                  if (result['success'] == true) {
                    // Hapus token lokal jika perlu, lalu navigasi ke halaman login
                    Navigator.of(context).pushReplacementNamed('/login');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result['error'] ?? 'Logout gagal')),
                    );
                  }
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}