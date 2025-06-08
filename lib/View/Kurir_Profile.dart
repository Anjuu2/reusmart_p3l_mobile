import 'package:flutter/material.dart';
import 'package:reusmart_mobile/client/KurirClient.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KurirProfile extends StatefulWidget {
  final String namaKurir;

  const KurirProfile({Key? key, required this.namaKurir}) : super(key: key);

  @override
  _KurirProfileState createState() => _KurirProfileState();
}

class _KurirProfileState extends State<KurirProfile> {
  final KurirClient _kurirClient = KurirClient();
  final _storage = const FlutterSecureStorage();

  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchKurirProfile();
  }

  Future<Map<String, dynamic>> _fetchKurirProfile() async {
    // Ambil token dari secure storage (atau simpan token di variabel global)
    String? token = await _storage.read(key: 'api_token');

    if (token == null) {
      return {'success': false, 'error': 'Token tidak ditemukan'};
    }

    final profileData = await _kurirClient.getKurirProfile(token);
    return profileData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Kurir')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            if (data['success'] == false) {
              return Center(child: Text('Error: ${data['error']}'));
            }

            final profile = data['data'];
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nama: ${profile['nama_pegawai']}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Email: ${profile['email'] ?? '-'}'),
                  Text('No. Telepon: ${profile['notelp'] ?? '-'}'),
                  Text('Tanggal Lahir: ${profile['tanggal_lahir'] ?? '-'}'),
                  Text('Jabatan: ${profile['jabatan'] ?? '-'}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
