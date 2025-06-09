import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reusmart_mobile/client/PembeliClient.dart';

class PembeliHistoryPage extends StatefulWidget {
  const PembeliHistoryPage({Key? key}) : super(key: key);

  @override
  State<PembeliHistoryPage> createState() => _PembeliHistoryPageState();
}

class _PembeliHistoryPageState extends State<PembeliHistoryPage> {
  final _client = PembeliClient();
  final _storage = FlutterSecureStorage();
  String searchQuery = '';
  String selectedStatus = 'Semua'; 

  late Future<Map<String, dynamic>> _historyFuture;
  List<dynamic> transaksiList = [];

  @override
  void initState() {
    super.initState();
    _historyFuture = _fetchHistory();
  }

  Future<Map<String, dynamic>> _fetchHistory() async {
    final token = await _storage.read(key: 'api_token');
    if (token == null) return {'success': false, 'error': 'Token tidak ditemukan'};
    final result = await _client.getPembeliHistoryPembelian(token);

    if (result['success'] == true) {
      transaksiList = result['data']['data'];
    }

    return result;
  }

  Widget _buildBarangList(List<dynamic> detailList) {
    return Column(
      children: List.generate(detailList.length, (index) {
        final detail = detailList[index];
        final barang = detail['barang'];
        final namaBarang = barang?['nama_barang'] ?? 'Barang sudah dihapus';
        final harga = barang?['harga_jual'] ?? detail['sub_total'];

        return Column(
          children: [
            ListTile(
              title: Text(namaBarang),
              trailing: Text(
                "Rp${harga.toString().replaceAllMapped(
                  RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                  (m) => '${m[1]}.',
                )}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (index != detailList.length - 1)
              const Divider(height: 1.3, color: Colors.grey),
          ],
        );
      }),
    );
  }

  Widget _buildTransaksiCard(Map<String, dynamic> transaksi) {
    final id = transaksi['id_transaksi'];
    final statusTransaksi = transaksi['status_transaksi'];
    final statusPengiriman = transaksi['status_pengiriman'];
    final total = transaksi['total_pembayaran'];
    final detailList = transaksi['detail_transaksi'] as List<dynamic>;
    final tanggalRaw = transaksi['tanggal_transaksi'];
    final tanggal = DateTime.tryParse(tanggalRaw) ?? DateTime.now();
    final tanggalFormatted = "${tanggal.day.toString().padLeft(2, '0')}/${tanggal.month.toString().padLeft(2, '0')}/${tanggal.year}";

    String tanggalKeluarFormatted = '-';
    if (detailList.isNotEmpty &&
        detailList.first['barang'] != null &&
        detailList.first['barang']['tanggal_keluar'] != null) {
      final tglKeluarRaw = detailList.first['barang']['tanggal_keluar'];
      final tglKeluarDate = DateTime.tryParse(tglKeluarRaw);
      if (tglKeluarDate != null) {
        tanggalKeluarFormatted = "${tglKeluarDate.day.toString().padLeft(2, '0')}/${tglKeluarDate.month.toString().padLeft(2, '0')}/${tglKeluarDate.year}";
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffe7f0da),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID Transaksi: $id",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Tgl Mulai: $tanggalFormatted",
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Tgl Akhir: $tanggalKeluarFormatted",
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Status: $statusTransaksi",
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Posisi: ${statusPengiriman ?? 'Belum ada'}",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Text(
                    "Rp${total.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          _buildBarangList(detailList),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pembelian"),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!['success'] != true) {
            return Center(child: Text(snapshot.data?['error'] ?? 'Gagal memuat data'));
          }

          final transaksiList = snapshot.data!['data']['data'] as List<dynamic>;

          final filteredRiwayat = transaksiList.where((item) {
          final idTransaksi = item['id_transaksi'].toString().toLowerCase();
          final status = item['status_transaksi'].toString().toLowerCase();

          // Cari nama barang dalam detail transaksi
          final detailList = item['detail_transaksi'] as List<dynamic>;
          final containsBarang = detailList.any((detail) {
            final namaBarang = detail['barang']?['nama_barang']?.toString().toLowerCase() ?? '';
            return namaBarang.contains(searchQuery);
          });

          final matchesSearch = idTransaksi.contains(searchQuery) || status.contains(searchQuery) || containsBarang;
          final matchesDropdown = selectedStatus == 'Semua' || status == selectedStatus.toLowerCase();

          return matchesSearch && matchesDropdown;
        }).toList();

          return Column(
            children: [
              // Search & Dropdown sejajar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari Transaksi...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          isDense: true,
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: selectedStatus,
                        isDense: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                          DropdownMenuItem(value: 'Disiapkan', child: Text('Disiapkan')),
                          DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
                          DropdownMenuItem(value: 'Batal', child: Text('Batal')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Kalau kosong tampil pesan, kalau ada tampil list
              if (filteredRiwayat.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Tidak ada transaksi yang cocok.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredRiwayat.length,
                    itemBuilder: (context, index) {
                      final transaksi = filteredRiwayat[index] as Map<String, dynamic>;
                      return _buildTransaksiCard(transaksi);
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
