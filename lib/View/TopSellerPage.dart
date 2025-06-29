import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reusmart_mobile/entity/TopSeller.dart';
import 'package:reusmart_mobile/entity/Penitip.dart';

class TopSellerPage extends StatefulWidget {
  const TopSellerPage({super.key});

  @override
  _TopSellerPageState createState() => _TopSellerPageState();
}

class _TopSellerPageState extends State<TopSellerPage> {
  static const apiUrl = 'http://reusemart.shop/api';
  TopSeller? _topSeller;
  Penitip? _penitip;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final res = await http.get(Uri.parse('http://reusemart.shop/api/top-seller'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body)['data'];
        print('Raw data: ${res.body}');
        print('Parsed data: $data');
        if (data != null) {
          setState(() {
          _topSeller = TopSeller.fromJson(data);
          _loading = false;
        });
        } else {
          setState(() => _loading = false);
        }
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      print('Error: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Top Seller"),centerTitle: true),
      body: _loading
    ? Center(child: CircularProgressIndicator())
    : _topSeller == null
        ? Center(child: Text("Belum ada Top Seller bulan ini."))
        : Center(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400), // Biar ga terlalu lebar
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Biar tidak mengisi penuh
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text("🎖️ Top Seller Bulan Ini", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 300), // Ubah sesuai kebutuhan
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "🎖️ Nama Penitip: ${_topSeller!.namaPenitip}",
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Total Penjualan: Rp ${_topSeller!.totalPenjualan.toStringAsFixed(0)}",
                                style: TextStyle(color: Colors.green[800]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Text("Bonus: Rp ${_topSeller!.bonus.toStringAsFixed(0)}", style: TextStyle(color: Colors.blue)),
                      // Text("Periode: ${_topSeller!.periode.month}/${_topSeller!.periode.year}"),
                  ],
                      ),
                    ),
                  ),
                  )          ),
    );
  }
}
