import 'package:flutter/material.dart';
import 'package:reusmart_mobile/client/KurirClient.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KurirHistoryPengirimanPage extends StatefulWidget {
  const KurirHistoryPengirimanPage({Key? key}) : super(key: key);

  @override
  State<KurirHistoryPengirimanPage> createState() => _KurirHistoryPengirimanPageState();
}

class _KurirHistoryPengirimanPageState extends State<KurirHistoryPengirimanPage> {
  final KurirClient _kurirClient = KurirClient();
  final _storage = const FlutterSecureStorage();
  late Future<Map<String, dynamic>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _fetchHistory();
  }

  Future<Map<String, dynamic>> _fetchHistory() async {
    String? token = await _storage.read(key: 'api_token');
    if (token == null) {
      return {'success': false, 'error': 'Token tidak tersedia.'};
    }
    return await _kurirClient.getKurirHistoryPengiriman(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Pengiriman'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _historyFuture,
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
            return const Center(child: Text('Belum ada pengiriman yang sampai.'));
          }

          return ListView.builder(
            itemCount: pengirimanList.length,
            itemBuilder: (context, index) {
              final pengiriman = pengirimanList[index];
              final idPengiriman = pengiriman['id_pengiriman']?.toString() ?? '-';
              final namaBarang = pengiriman['nama_barang'] ?? '-';
              final tanggalJadwal = pengiriman['tanggal_jadwal'] ?? '-';
              final statusPengiriman = pengiriman['status_pengiriman'] ?? '-';

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
                      Text('Status: $statusPengiriman'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
