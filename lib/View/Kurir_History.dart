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
            return Center(child: Text(data['message'] ?? 'Gagal memuat data.'));
          }

          final pengirimanList = data['data'] as List<dynamic>;
          if (pengirimanList.isEmpty) {
            return const Center(child: Text('Belum ada pengiriman yang sampai.'));
          }

          return ListView.builder(
            itemCount: pengirimanList.length,
            itemBuilder: (context, index) {
              final pengiriman = pengirimanList[index];
              final idPengirim = pengiriman['id_pengirim'] ?? '-';
              final idTransaksi = pengiriman['id_transaksi'] ?? '-';
              final metode = pengiriman['metode_pengiriman'] ?? '-';
              final tanggal = pengiriman['created_at'] ?? '-'; // Pastikan field ini tersedia di API

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.local_shipping, color: Color.fromRGBO(0, 128, 0, 0.7)),
                  title: Text('ID Pengiriman: $idPengirim'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID Transaksi: $idTransaksi'),
                      Text('Metode: $metode'),
                      Text('Tanggal: $tanggal'),
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
