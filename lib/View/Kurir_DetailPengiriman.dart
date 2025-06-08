import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reusmart_mobile/client/KurirClient.dart';

class KurirDetailPengirimanPage extends StatefulWidget {
  final String idPengiriman;

  const KurirDetailPengirimanPage({Key? key, required this.idPengiriman}) : super(key: key);

  @override
  State<KurirDetailPengirimanPage> createState() => _KurirDetailPengirimanPageState();
}

class _KurirDetailPengirimanPageState extends State<KurirDetailPengirimanPage> {
  final KurirClient _kurirClient = KurirClient();
  final _storage = const FlutterSecureStorage();
  late Future<Map<String, dynamic>> _detailFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _detailFuture = _fetchDetail();
  }

  Future<Map<String, dynamic>> _fetchDetail() async {
    String? token = await _storage.read(key: 'api_token');
    if (token == null) {
      return {'success': false, 'error': 'Token tidak tersedia.'};
    }
    return await _kurirClient.getDetailPengiriman(token, widget.idPengiriman);
  }

  Future<void> _konfirmasiPengiriman() async {
    setState(() {
      _isLoading = true;
    });

    String? token = await _storage.read(key: 'api_token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token tidak tersedia.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final result = await _kurirClient.konfirmasiPengiriman(token, widget.idPengiriman);
    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengiriman telah dikonfirmasi.')),
      );
      Navigator.pop(context, true); // Pop dan kembalikan ke dashboard
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error'] ?? 'Gagal konfirmasi pengiriman.')),
      );
    }
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color.fromRGBO(0, 128, 0, 0.7)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
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
        title: const Text('Detail Pengiriman'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          if (data['success'] == false) {
            return Center(child: Text(data['error'] ?? 'Gagal memuat detail.'));
          }

          final detail = data['data'];
          final idPengiriman = detail['id_pengiriman']?.toString() ?? '-';
          final namaBarang = detail['nama_barang'] ?? '-';
          final tanggalJadwal = detail['tanggal_jadwal'] ?? '-';
          final statusPengiriman = detail['status_pengiriman'] ?? '-';
          final namaPembeli = detail['nama_pembeli'] ?? '-';
          final alamatPembeli = detail['alamat_pembeli'] ?? '-';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Pengiriman',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 128, 0, 0.7),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        _buildDetailItem(Icons.confirmation_number, 'ID Pengiriman', idPengiriman),
                        const Divider(),
                        _buildDetailItem(Icons.inventory_2, 'Nama Barang', namaBarang),
                        const Divider(),
                        _buildDetailItem(Icons.calendar_today, 'Tanggal Jadwal', tanggalJadwal),
                        const Divider(),
                        _buildDetailItem(Icons.check_circle, 'Status', statusPengiriman),
                        const Divider(),
                        _buildDetailItem(Icons.person, 'Nama Pembeli', namaPembeli),
                        const Divider(),
                        _buildDetailItem(Icons.location_on, 'Alamat Pembeli', alamatPembeli),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _konfirmasiPengiriman,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Konfirmasi Pengiriman', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
