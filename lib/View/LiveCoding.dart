import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reusmart_mobile/client/HunterClient.dart';

class LiveCoding extends StatefulWidget {
  const LiveCoding({super.key});

  @override
  State<LiveCoding> createState() => _LiveCodingState();
}

class _LiveCodingState extends State<LiveCoding> {
  final HunterClient _hunterClient = HunterClient();
  final _storage = const FlutterSecureStorage();

  late Future<List<dynamic>> _komisiFuture;
  int? _selectedMonth;
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now().month;
    _selectedYear = DateTime.now().year;
    _komisiFuture = _fetchKomisiHistory();
  }

  Future<List<dynamic>> _fetchKomisiHistory() async {
    String? token = await _storage.read(key: 'api_token');
    if (token == null) {
      return [];
    }

    final response = await _hunterClient.getHistoryKomisiHunterLiveCode(
      token,
      month: _selectedMonth,
      year: _selectedYear,
    );
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
        backgroundColor: const Color.fromARGB(179, 255, 255, 255),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMonthDropdown(),
                _buildYearDropdown(),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
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
          ),
        ],
      ),
    );
  }

  Widget _buildMonthDropdown() {
    return DropdownButton<int>(
      value: _selectedMonth,
      items: List.generate(12, (index) {
        final month = index + 1;
        return DropdownMenuItem<int>(
          value: month,
          child: Text('Bulan $month'),
        );
      }),
      onChanged: (month) {
        setState(() {
          _selectedMonth = month;
          _komisiFuture = _fetchKomisiHistory();
        });
      },
    );
  }

  Widget _buildYearDropdown() {
    return DropdownButton<int>(
      value: _selectedYear,
      items: List.generate(5, (index) {
        final year = DateTime.now().year - (4 - index);
        return DropdownMenuItem<int>(
          value: year,
          child: Text(year.toString()),
        );
      }),
      onChanged: (year) {
        setState(() {
          _selectedYear = year;
          _komisiFuture = _fetchKomisiHistory();
        });
      },
    );
  }
}

