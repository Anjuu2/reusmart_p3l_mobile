import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reusmart_mobile/entity/BarangTitipan.dart';
import 'package:reusmart_mobile/entity/Kategori.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math';
import 'package:reusmart_mobile/View/AboutUs.dart';
import 'package:reusmart_mobile/View/Login.dart';
import 'package:reusmart_mobile/entity/Penitip.dart';
import 'package:reusmart_mobile/entity/TopSeller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _banners = [];
  List<Kategori> _categories = [];
  List<BarangTitipan> _products = [];
  List<BarangTitipan> _dashboardProducts = [];
  bool _isLoading = true;
  int _selectedCategoryId = 0;  // Simpan kategori yang dipilih
  static const apiUrl = 'http://10.0.2.2:8000/api';  // Ganti sesuai dengan URL API Anda
  static const hostUrl = 'http://10.0.2.2:8000';

  TopSeller? _topSeller;
  Penitip? _topSellerInfo;


  final List<Widget> _pages = [
    HomePage(),    
  ];

  @override
  void initState() {
    super.initState();
    _initData();
    _loadTopSeller();
  }

  // Fungsi untuk mengambil data kategori dan produk secara paralel
  Future<void> _initData() async {
    // Menjalankan pemanggilan API secara paralel
    await Future.wait([_loadCategories(), _loadProducts()]);

    // Pilih beberapa produk acak untuk banner
    final randomList = List.of(_products)..shuffle();
    final dashList = randomList.take(6).toList();

    final banners = dashList.take(3).map((p) {
      final fn = p.fotoBarang.isNotEmpty ? p.fotoBarang.first.namaFile : 'default.jpg';
      return '$hostUrl/images/barang/$fn';
    }).toList();

    setState(() {
      _dashboardProducts = dashList;
      _banners = banners;
      _isLoading = false;
    });
  }

  Future<void> _loadTopSeller() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/top-seller/current-month'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'];
        final seller = TopSeller.fromJson(data);
        final penitipRes = await http.get(Uri.parse('$apiUrl/penitip/${seller.idPenitip}'));
        if (penitipRes.statusCode == 200) {
          final penitipData = json.decode(penitipRes.body)['data'];
          setState(() {
            _topSeller = seller;
            _topSellerInfo = Penitip.fromJson(penitipData);
          });
        }
      }
    } catch (e) {
      debugPrint('Failed to load top seller: $e');
    }
  }

  Future<void> _loadCategories() async {
    final res = await http.get(
      Uri.parse('$apiUrl/kategori'),
      headers: {'Accept': 'application/json'},
    );

    if (res.statusCode == 200) {
      final body = json.decode(res.body) as Map<String, dynamic>;
      final list = body['data'] as List<dynamic>;
      setState(() {
        _categories = list.map((e) => Kategori.fromJson(e)).toList();
      });
    } else {
      debugPrint('Failed to load categories');
    }
  }

  // Fungsi untuk mengambil produk dari API
  Future<void> _loadProducts([int? categoryId]) async {
    final url = categoryId == null
        ? '$apiUrl/barangs'  // Ambil semua produk
        : '$apiUrl/kategori/$categoryId/produk'; // Ambil produk berdasarkan kategori
    final res = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json'},
    );

    if (res.statusCode == 200) {
      final body = json.decode(res.body) as Map<String, dynamic>;
      final list = body['data'] as List<dynamic>;
      setState(() {
        _products = list.map((e) => BarangTitipan.fromJson(e)).toList();
      });
    } else {
      debugPrint('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo2.png', height: 40),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator()) // Menampilkan loading spinner
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Carousel
                    SizedBox(
                      height: 180,
                      child: PageView.builder(
                        itemCount: _banners.length,
                        controller: PageController(viewportFraction: 0.9),
                        itemBuilder: (ctx, i) {
                          final p = _dashboardProducts[i];
                          final filename = p.fotoBarang.isNotEmpty
                              ? p.fotoBarang.first.namaFile
                              : 'default.jpg';
                          final imageUrl = '$hostUrl/images/barang/$filename';

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Icon(Icons.broken_image, size: 60),
                                  ),
                                  // Overlay nama barang
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      color: Colors.black54,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      child: Text(
                                        p.namaBarang,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 16),

              if (_topSeller != null && _topSellerInfo != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.amber,
                            child: Icon(Icons.star, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '🎖️ Top Seller Bulan Ini',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  '${_topSellerInfo!.namaPenitip}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Total Penjualan: Rp ${_topSeller!.totalPenjualan}',
                                  style: TextStyle(color: Colors.green[800]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Judul “Terpopuler”
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Terpopuler',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),

                    // Grid Produk (mengisi sisa layar)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(12),
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.95,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _dashboardProducts.length,
                        itemBuilder: (_, idx) {
                          final p = _dashboardProducts[idx];
                          final filename = p.fotoBarang.isNotEmpty
                              ? p.fotoBarang.first.namaFile
                              : 'default.jpg';
                          final imageUrl = '$hostUrl/images/barang/$filename';

                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        height: 100,
                                        width: double.infinity,
                                        color: Colors.white,
                                      ),
                                    ),
                                    errorWidget: (_, __, ___) => Image.asset(
                                      'assets/images/default.jpg',
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Text(
                                    p.namaBarang,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    'Rp${p.hargaJual?.toStringAsFixed(0) ?? '0'}',
                                    style: TextStyle(color: Colors.green[700]),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 16),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to the All Products page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AllProductsPage(), // New Page
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Lihat Semua Produk',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    AboutUsSection(),

                    SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }
}
