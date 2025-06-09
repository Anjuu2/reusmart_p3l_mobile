import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async'; // Untuk debounce

class AllProductsPage extends StatefulWidget {
  @override
  _AllProductsPageState createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  List<Map<String, dynamic>> _allProducts = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<String> categories = ["Semua", "Category 1", "Category 2", "Category 3"]; // Example categories
  String selectedCategory = "";

  static const apiUrl = 'http://10.0.2.2:8000/api';

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();  // Load initial products
  }

  // Fetch all products or products based on search query
  Future<void> _fetchAllProducts([String? query]) async {
    final url = query == null
        ? '$apiUrl/barangsMobile'  // Fetch all products if no query
        : '$apiUrl/barangsMobile?search=$query';  // Use search query if provided

    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> list = body['data'];
      setState(() {
        _allProducts = List<Map<String, dynamic>>.from(list);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load products');
    }
  }

  // Fetch product by ID
  Future<void> _fetchProductById(String id) async {
    final url = '$apiUrl/barangsMobile/$id';  // Fetch product by ID

    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      setState(() {
        _allProducts = [body['data']];  // Return a single product
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load product details');
    }
  }

  // Format price as "Rp. 000.000.000"
  String formatPrice(int price) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return format.format(price);
  }

  // Handle search input with debounce
  void _debounceFetch() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchAllProducts(_searchController.text);  // Fetch products based on search term
    });
  }

  // Handle submit search when pressing Enter
  void _onSearchSubmit(String value) {
    _fetchAllProducts(value);  // Trigger search with query
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Produk'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search Field
            SizedBox(
              height: 60,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Cari nama barang...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
                onChanged: (value) {
                  _debounceFetch(); // Call debounce function on input change
                },
                onSubmitted: _onSearchSubmit,  // Handle submit when pressing Enter
              ),
            ),
            const SizedBox(height: 10), // Space between search field and category filter

            // Category Filter (you can extend this part based on your categories)
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedCategory = category;
                          });
                          _fetchAllProducts();  // Fetch products based on selected category
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedCategory == category
                              ? Colors.green
                              : Colors.grey[200],
                          foregroundColor: selectedCategory == category
                              ? Colors.white
                              : Colors.black,
                        ),
                        child: Text(category),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Displaying Products Grid
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    flex: 10,
                    child: GridView.builder(
                      itemCount: _allProducts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final product = _allProducts[index];
                        final imageUrl = 'http://10.0.2.2:8000/images/barang/${product['foto_barang'][0]['nama_file'] ?? 'default.jpg'}';

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                height: 150,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  product['nama_barang'] ?? '-',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  formatPrice(product['harga_jual']),  // Format price
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
