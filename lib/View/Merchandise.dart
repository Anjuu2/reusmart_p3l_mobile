import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reusmart_mobile/View/Pembeli_profile.dart';
import 'package:reusmart_mobile/client/PembeliClient.dart';
// import 'package:reusmart_mobile/View/Pembeli_Dashboard.dart';
import 'package:reusmart_mobile/View/RewardHistoryPage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MerchandisePage extends StatefulWidget {
  final String namaPembeli;

  const MerchandisePage({Key? key, required this.namaPembeli}) : super(key: key);

  @override
  State<MerchandisePage> createState() => _MerchandisePageState();
}

class _MerchandisePageState extends State<MerchandisePage> {
  final PembeliClient _pembeliClient = PembeliClient();
  final _storage = const FlutterSecureStorage();
  late Future<List<Map<String, dynamic>>> _merchandiseFuture;
  int? _idPembeli;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    await _getIdPembeli();
    setState(() {
      _merchandiseFuture = _fetchMerchandise();
    });
  }

  Future<void> _getIdPembeli() async {
    String? idPembeliStr = await _storage.read(key: 'id_pembeli');
    if (idPembeliStr != null) {
      _idPembeli = int.tryParse(idPembeliStr);
    }
  }

  Future<List<Map<String, dynamic>>> _fetchMerchandise() async {
    String? token = await _storage.read(key: 'api_token');
    if (token == null) {
      return [];
    }
    final result = await _pembeliClient.getMerchandiseList(token);
    if (result['success'] == true) {
      return List<Map<String, dynamic>>.from(result['data']);
    } else {
      return [];
    }
  }

  Future<void> _showClaimConfirmationDialog(
      int idMerchandise, String namaBarang, int jumlahPoin) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Klaim'),
        content: Text(
          'Apakah Anda ingin mengklaim "$namaBarang" dengan $jumlahPoin poin?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, // White text color
                          ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Klaim'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _claimMerchandise(idMerchandise, namaBarang, jumlahPoin);
    }
  }

  Future<void> _claimMerchandise(int idMerchandise, String namaBarang, int jumlahPoin) async {
    String? token = await _storage.read(key: 'api_token');
    if (token == null || _idPembeli == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal klaim. Token atau ID pembeli tidak ditemukan.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Memproses klaim...')),
    );

    final result = await _pembeliClient.claimMerchandise(token, _idPembeli!, idMerchandise);
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // hide loading

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berhasil klaim "$namaBarang"!')),
      );
      setState(() {
        _merchandiseFuture = _fetchMerchandise(); // refresh stok
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal klaim: ${result['error'] ?? 'Terjadi kesalahan.'}')),
      );
    }
    print('Gagal klaim: ${result['error']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchandise'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RewardHistoryPage()),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _merchandiseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          final merchandiseList = snapshot.data ?? [];
          if (merchandiseList.isEmpty) {
            return const Center(child: Text('Belum ada data merchandise.'));
          }
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: merchandiseList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final item = merchandiseList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Gambar
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: CachedNetworkImage(
                            imageUrl: item['gambar_url'] ?? '',
                            fit: BoxFit.cover,
                            errorWidget: (context, error, stackTrace) {
                              return CachedNetworkImage(
                                    imageUrl: 'https://banksuryaarthautama.co.id/wp-content/themes/carlax/images/no-image.jpg',
                                    fit: BoxFit.cover,
                                    errorWidget: (context, error, stackTrace) {
                                      return const Center(
                                        child: CircularProgressIndicator(),  // Optionally, you can show a loading indicator while the image loads
                                      );
                                    },
                                  );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Text(
                          item['nama_merchandise'] ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Poin: ${item['jumlah_poin']}',
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Text(
                          'Stok: ${item['banyak_merchandise']}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _showClaimConfirmationDialog(
                              item['id_merchandise'],
                              item['nama_merchandise'],
                              item['jumlah_poin'],
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7), // Green background
                            foregroundColor: Colors.white, // White text color
                          ),
                          child: const Text('Klaim'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 1,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
      //     BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Merchandise'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      //   ],
      //   onTap: (index) {
      //     if (index == 0) {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //           builder: (_) => PembeliDashboard(namaPembeli: widget.namaPembeli),
      //         ),
      //       );
      //     } else if (index == 2) {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //           builder: (_) => PembeliProfile(namaPembeli: widget.namaPembeli),
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
