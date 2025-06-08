import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reusmart_mobile/client/KurirClient.dart';
import 'package:reusmart_mobile/View/Kurir_profile.dart';
import 'package:reusmart_mobile/View/Kurir_DetailPengiriman.dart';

class KurirDashboard extends StatefulWidget {
  final String namaKurir;
  const KurirDashboard({Key? key, required this.namaKurir}) : super(key: key);

  @override
  State<KurirDashboard> createState() => _KurirDashboardState();
}

class _KurirDashboardState extends State<KurirDashboard> {
  final KurirClient _kurirClient = KurirClient();
  final _storage = const FlutterSecureStorage();
  late Future<Map<String, dynamic>> _pengirimanFuture;

  @override
  void initState() {
    super.initState();
    _pengirimanFuture = _fetchPengiriman();
  }

  Future<Map<String, dynamic>> _fetchPengiriman() async {
    String? token = await _storage.read(key: 'api_token');
    if (token == null) {
      return {'success': false, 'error': 'Token tidak tersedia.'};
    }
    return await _kurirClient.getKurirPengiriman(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat datang, ${widget.namaKurir}'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _pengirimanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          if (data['success'] == false) {
            return Center(child: Text(data['error'] ?? 'Gagal memuat data.'));
          }

          final pengirimanList = data['data'] as List<dynamic>;
          if (pengirimanList.isEmpty) {
            return const Center(child: Text('Belum ada pengiriman yang tersedia.'));
          }

          return ListView.builder(
            itemCount: pengirimanList.length,
            itemBuilder: (context, index) {
              final pengiriman = pengirimanList[index];
              final idPengiriman = pengiriman['id_pengiriman']?.toString() ?? '-';
              final namaBarang = pengiriman['nama_barang'] ?? '-';
              final tanggalJadwal = pengiriman['tanggal_jadwal'] ?? '-';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.local_shipping, color: Color.fromRGBO(0, 128, 0, 0.7)),
                  title: Text(namaBarang, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID Pengiriman: $idPengiriman'),
                      Text('Tanggal Jadwal: $tanggalJadwal'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KurirDetailPengirimanPage(idPengiriman: idPengiriman),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // index 0 karena ini dashboard
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => KurirProfile(namaKurir: widget.namaKurir),
              ),
            );
          }
        },
      ),
    );
  }
}
