import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reusmart_mobile/client/PembeliClient.dart';

class RewardHistoryPage extends StatefulWidget {
  const RewardHistoryPage({Key? key}) : super(key: key);

  @override
  State<RewardHistoryPage> createState() => _RewardHistoryPageState();
}

class _RewardHistoryPageState extends State<RewardHistoryPage> {
  final PembeliClient _pembeliClient = PembeliClient();
  final _storage = const FlutterSecureStorage();
  late Future<List<Map<String, dynamic>>> _historyFuture;
  int? _idPembeli;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    String? idPembeliStr = await _storage.read(key: 'id_pembeli');
    if (idPembeliStr != null) {
      _idPembeli = int.tryParse(idPembeliStr);
      setState(() {
        _historyFuture = _fetchHistory();
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchHistory() async {
    String? token = await _storage.read(key: 'api_token');
    if (token == null || _idPembeli == null) {
      return [];
    }
    final result = await _pembeliClient.getRewardHistory(token, _idPembeli!);
    if (result['success'] == true) {
      return List<Map<String, dynamic>>.from(result['data']);
    } else {
      return [];
    }
  }

  Widget _buildDetailText(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Klaim Merchandise'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( // Use FutureBuilder to display reward history data
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator while waiting
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}')); // Display error message
          }
          final historyList = snapshot.data ?? [];
          if (historyList.isEmpty) {
            return const Center(child: Text('Belum ada history klaim.')); // Show if no history
          }
          return ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final item = historyList[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(item['nama_merchandise'] ?? '-'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailText('Poin:', item['jumlah_tukar_poin']),
                      _buildDetailText('Tanggal Klaim:', item['tanggal_klaim']),
                      _buildDetailText('Tanggal Ambil:', item['tanggal_ambil']),
                      _buildDetailText('Status:', item['status_penukaran']),
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
