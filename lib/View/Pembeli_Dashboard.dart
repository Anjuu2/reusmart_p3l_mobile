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
import 'package:reusmart_mobile/View/Merchandise.dart';
import 'package:reusmart_mobile/View/Pembeli_profile.dart';

class PembeliDashboard extends StatefulWidget {
  final String namaPembeli;
  const PembeliDashboard({Key? key, required this.namaPembeli}) : super(key: key);

  @override
  _PembeliDashboardState createState() => _PembeliDashboardState();
}

class _PembeliDashboardState extends State<PembeliDashboard> {
  List<String> _banners = [];
  List<Kategori> _categories = [];
  List<BarangTitipan> _products = [];
  List<BarangTitipan> _dashboardProducts = [];
  bool _isLoading = true;
  int? _selectedCategoryId;
  static const apiUrl  = 'http://10.0.2.2:8000/api';
  static const hostUrl = 'http://10.0.2.2:8000';

  final List<Widget> _pages = [
    PembeliDashboard(namaPembeli: 'default'),
  ];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _loadCategories();
    await _loadProducts();

    final randomList = List.of(_products)..shuffle();
    final dashList = randomList.take(6).toList();
    final banners = dashList.take(3).map((p) {
      final fn = p.fotoBarang.isNotEmpty
        ? p.fotoBarang.first.namaFile
        : 'default.jpg';
      return '$hostUrl/images/barang/$fn';
    }).toList();

    setState(() {
      _dashboardProducts = dashList;
      _banners = banners;
      _isLoading = false;
    });
  }

  Future<void> _loadCategories() async {
    final res = await http.get(
      Uri.parse('$apiUrl/kategori'),
      headers: { 'Accept': 'application/json' },  
    );
    if (res.statusCode == 200) {
      final body = json.decode(res.body) as Map<String, dynamic>;
      final list = body['data'] as List<dynamic>;
      setState(() {
        _categories = list.map((e) => Kategori.fromJson(e)).toList();
      });
    }
  }

  Future<void> _loadProducts([int? categoryId]) async {
    final url = categoryId == null
      ? '$apiUrl/barangs'
      : '$apiUrl/kategori/$categoryId/produk';
    final res = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json'},
    );

    if (res.statusCode == 200) {
      final body = json.decode(res.body) as Map<String, dynamic>;
      final list = body['data'] as List<dynamic>;
      setState(() {
        _products = list
          .map((e) => BarangTitipan.fromJson(e as Map<String, dynamic>))
          .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

                // Grid Produk
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

                // See All Products
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllProductsPage(),
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
              ],
            ),
          ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Merchandise',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PembeliProfile(namaPembeli: widget.namaPembeli)),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MerchandisePage(namaPembeli: widget.namaPembeli)),
            );
          }
        },
      ),
    );
  }
}
