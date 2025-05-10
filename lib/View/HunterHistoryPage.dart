import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reusmart_mobile/client/HunterClient.dart';

class HunterHistoryPage extends StatefulWidget {
  const HunterHistoryPage({super.key});

  @override
  State<HunterHistoryPage> createState() => _HunterHistoryPageState();
}

class _HunterHistoryPageState extends State<HunterHistoryPage> {
  final HunterClient _hunterClient = HunterClient();
  final _storage = const FlutterSecureStorage();

  late Future<List<dynamic>> _komisiFuture;

  @override
  void initState() {
    super.initState();
    _komisiFuture = _fetchKomisiHistory();
  }

  Future<List<dynamic>> _fetchKomisiHistory() async {
    String? token = await _storage.read(key: 'api_token');
    if (token == null) {
      return [];
    }

    final response = await _hunterClient.getHistoryKomisiHunter(token);
    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Komisi'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _komisiFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          if (data.isEmpty) {
            return const Center(child: Text('Tidak ada data komisi.'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final namaBarang = item['nama_barang'] ?? '-';
              final tanggalTransaksi = item['tanggal_transaksi'] ?? '-';
              final komisi = item['komisi_barang'] ?? 0;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.money, color: Colors.green),
                  title: Text(namaBarang),
                  subtitle: Text('Tanggal: $tanggalTransaksi'),
                  trailing: Text('Rp ${komisi.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
