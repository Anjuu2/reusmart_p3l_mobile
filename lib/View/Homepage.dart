import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reusmart_mobile/entity/BarangTitipan.dart';
import 'package:reusmart_mobile/entity/Kategori.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math';  
import 'package:reusmart_mobile/View/AboutUs.dart';
import 'package:reusmart_mobile/View/AllProductsPage.dart';

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
  int? _selectedCategoryId;
  static const apiUrl  = 'http://reusemart.shop/api';
  static const hostUrl = 'http://reusemart.shop';

  final List<Widget> _pages = [
    HomePage(),    
  ];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
  try {
    await Future.wait([
      _loadCategories(),
      _loadProducts()
    ]);

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
  } catch (e) {
    debugPrint("Gagal init data: $e");
    setState(() {
      _isLoading = false;
    });
  }
}


  Future<void> _loadCategories() async {
    final res = await http.get(
      Uri.parse('$apiUrl/kategori'),
      headers: { 'Accept': 'application/json' },  // ← tambahkan ini
    );
    if (res.statusCode == 200) {
      final body = json.decode(res.body) as Map<String, dynamic>;
      final list = body['data'] as List<dynamic>;
      setState(() {
        _categories = list.map((e) => Kategori.fromJson(e)).toList();
      });
    }
  }

  // New: ambil semua produk
  Future<void> _loadProducts([int? categoryId]) async {
    final url = categoryId == null
      ? '$apiUrl/barangs'
      : '$apiUrl/kategori/$categoryId/produk';
    debugPrint('[loadProducts] URL → $url');
    final res = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json'},
    );

    debugPrint('[loadProducts] status=${res.statusCode}');
    debugPrint('[loadProducts] body=${res.body.substring(0, min(200, res.body.length))}…');

    if (res.statusCode == 200) {
      final body = json.decode(res.body) as Map<String, dynamic>;
      final list = body['data'] as List<dynamic>;
      setState(() {
        _products = list
          .map((e) => BarangTitipan.fromJson(e as Map<String, dynamic>))
          .toList();
      });
    } else {
      debugPrint('[loadProducts] ERROR status ${res.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('ReUseMart'),
        centerTitle: true,                     
        title: Image.asset(
          'assets/images/logo2.png',
          height: 40,                            
        ),
        elevation: 0,
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1) Banner Carousel
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
                              left: 0, right: 0, bottom: 0,
                              child: Container(
                                color: Colors.black54,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                                child: Text(
                                  p.namaBarang,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
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
                  ),
                ),
              ),

              // 3) Grid Produk (mengisi sisa layar)
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
                  itemCount: _selectedCategoryId == null
                      ? _dashboardProducts.length    // di dashboard sebelum filter, tampilkan yang random
                      : _products.length,            // setelah filter, tampilkan semua di _products
                  itemBuilder: (_, idx) {
                    final p = (_selectedCategoryId == null
                        ? _dashboardProducts[idx]
                        : _products[idx]);
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
                                  fadeInDuration: Duration(milliseconds: 200),
                                ),
                              ),
                          // nama
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              p.namaBarang,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // harga
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
      )
    );
  }
}