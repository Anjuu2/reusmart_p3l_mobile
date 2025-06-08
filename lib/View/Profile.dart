import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Nanti di sini kamu akan panggil API user/profile atau
    // baca data user yang sudah login dari local storage/token.
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Saya'),
      ),
      body: Center(
        child: Text('Halaman Profil (belum di‐implement)'),
      ),
    );
  }
}
