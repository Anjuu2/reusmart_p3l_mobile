import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reusmart_mobile/client/PenitipClient.dart';
import 'package:reusmart_mobile/entity/BarangTitipan.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class PenitipFilterPage extends StatefulWidget {
  const PenitipFilterPage({Key? key}) : super(key: key);

  @override
  State<PenitipFilterPage> createState() => _PenitipFilterPageState();
}

class _PenitipFilterPageState extends State<PenitipFilterPage> {
  final _storage = const FlutterSecureStorage();
  final PenitipClient _client = PenitipClient();

  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoading = false;
  bool _isInitialLoad = true;
  List<BarangTitipan> _historyList = [];
  final ScrollController _scrollController = ScrollController();

  // Tambahkan di atas class
  // final List<String> _statusList = ['Semua', 'Tersedia', 'Terjual', 'Didonasikan', 'Diambil Kembali', 'Barang Untuk Donasi'];
  final List<String> _statusList = ['Semua', 'Tersedia', 'Terjual', 'Didonasikan'];


  // Dalam State
  String _searchQuery = '';
  String _selectedStatus = 'Semua';
  TextEditingController _searchController = TextEditingController();

  static const hostUrl = 'http://reusemart.shop';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchHistory(); // Awal
    _scrollController.addListener(_onScroll);

    _searchController.addListener(() {
      _searchQuery = _searchController.text;
      _fetchHistory();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _currentPage < _lastPage) {
        _fetchHistory(isLoadMore: true);
      }
    }
  }

  String getFotoUrl(BarangTitipan p) {
    final fn = p.fotoBarang.isNotEmpty ? p.fotoBarang.first.namaFile : 'default.jpg';
    return '$hostUrl/images/barang/$fn';
  }

  String formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void _debounceFetch() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchHistory();
    });
  }

  Future<void> _fetchHistory({bool isLoadMore = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final token = await _storage.read(key: 'api_token');
    if (token == null) {
      setState(() => _isLoading = false);
      return;
    }

    final pageToLoad = isLoadMore ? _currentPage + 1 : 1;
    final result = await _client.getPenitipHistoryTitipan(
      token,
      page: pageToLoad,
      search: _searchQuery,
      status: _selectedStatus,
    );

    if (result['success'] == true) {
      final list = (result['data'] as List<dynamic>)
          .map((e) => BarangTitipan.fromJson(e as Map<String, dynamic>))
          .toList();

      setState(() {
        _currentPage = result['pagination']['current_page'];
        _lastPage = result['pagination']['last_page'];

        if (isLoadMore) {
          _historyList.addAll(list);
        } else {
          _historyList = list;
        }

        _isInitialLoad = false;
      });
    }

    setState(() => _isLoading = false);
  }

  Color getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    final s = status.toLowerCase();

    // if (s == 'tersedia') return Colors.green;
    // if (['terjual', 'diambil kembali', 'pengambilan diproses'].contains(s)) return Colors.red;
    // if (s == 'didonasikan') return Colors.purple;
    // if (s == 'barang untuk donasi') return Colors.orange;
    // if (s == 'diambil kembali') return Colors.blue;

    if (s == 'tersedia') return Colors.green;
    if (['terjual', 'diambil kembali', 'pengambilan diproses'].contains(s)) return Colors.red;
    if (s == 'didonasikan') return Colors.purple;
    if (s == 'barang untuk donasi') return Colors.orange;
    if (s == 'diambil kembali') return Colors.blue;

    return Colors.grey;
  }

  Widget buildItemCard(BarangTitipan item) {
    return SizedBox(
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      child: ListTile(
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(getFotoUrl(item)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.namaBarang,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Masuk: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(formatDate(item.tanggalMasuk)),
              ],
            ),
            // Row(
            //   children: [
            //     const Text('Akhir: ', style: TextStyle(fontWeight: FontWeight.bold)),
            //     Text(formatDate(item.tanggalAkhir)),
            //   ],
            // ),
          ],
        ),
        isThreeLine: true,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: getStatusColor(item.statusBarang).withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            item.statusBarang ?? '',
            style: TextStyle(
              color: getStatusColor(item.statusBarang),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Riwayat Penitipan'),
        // centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
      ),
      body: _isInitialLoad
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedStatus,
                    items: _statusList.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedStatus = newValue!;
                        _fetchHistory();
                      });
                    },
                    decoration: const InputDecoration(
                      // labelText: 'Status',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // 📦 List view of items
                Expanded(
                  child: _historyList.isEmpty
                      ? const Center(child: Text('Belum ada riwayat penitipan.'))
                      : ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _historyList.length + (_currentPage < _lastPage ? 1 : 0),
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            if (index == _historyList.length) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }

                            final item = _historyList[index];
                            return buildItemCard(item);
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
