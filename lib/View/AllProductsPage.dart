import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async'; // Untuk debounce
import 'DetailProductPage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AllProductsPage extends StatefulWidget {
  @override
  _AllProductsPageState createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  List<Map<String, dynamic>> _allProducts = [];
  bool _isLoading = true;
  bool _isError = false;  // Handle error state
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<String> categories = []; // Dynamic categories
  String selectedCategory = "Semua";  // Default category is "Semua"
  bool _isFetching = false; // Prevent multiple simultaneous fetches
  int _currentPage = 1; // Track the current page for pagination
  bool _hasMoreProducts = true; // Flag to check if there are more products

  static const apiUrl = 'http://10.0.2.2:8000/api';  // Make sure API is reachable

  @override
  void initState() {
    super.initState();
    _fetchCategories();  // Fetch categories on init
  }

  // Fetch categories from the API
  Future<void> _fetchCategories() async {
    final url = '$apiUrl/kategoriMobile';  // Endpoint for fetching categories

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final List<dynamic> list = body['data'];
        setState(() {
          categories = ['Semua'] + list.map<String>((category) => category['nama_kategori']).toList(); // Add "Semua"
        });
        // After categories are loaded, fetch products
        _fetchAllProducts();  
      } else {
        setState(() {
          _isLoading = false;
          _isError = true; // Set error state if categories fail to load
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
      print('Error fetching categories: $e');
    }
  }

  // Fetch products from the API
  Future<void> _fetchAllProducts([String? query]) async {
    if (_isFetching) return;  // Prevent multiple simultaneous fetches
    setState(() {
      _isFetching = true;
      _isLoading = true; // Set loading state to true while fetching data
    });

    // If query is empty, replace with an empty string ""
    final searchQuery = query?.isEmpty ?? true ? "" : query;

    final categoryId = selectedCategory != "Semua"
        ? categories.indexOf(selectedCategory)  // Find category ID based on name
        : null;

    final url = categoryId == null
        ? '$apiUrl/barangsMobile?search=$searchQuery&page=$_currentPage'  // Fetch all products with pagination
        : '$apiUrl/barangsMobile?search=$searchQuery&category_id=$categoryId&page=$_currentPage';  // Filter products based on search and category with pagination

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;

        if (body['data'] != null && body['data'] is Map<String, dynamic>) {
          final data = body['data'];

          // Ensure 'data' is a Map and 'data['data']' contains a list
          if (data['data'] is List) {
            final List<dynamic> products = data['data'];

            setState(() {
              _allProducts.addAll(products.map<Map<String, dynamic>>((product) => Map<String, dynamic>.from(product)));
              _isLoading = false;
              _isFetching = false;
              _currentPage++; // Increment the page number for the next fetch
              _hasMoreProducts = data['next_page_url'] != null; // Check if there are more pages
            });
          } else {
            setState(() {
              _isLoading = false;
              _isFetching = false;
            });
            throw Exception('Data produk tidak ditemukan');
          }
        } else {
          setState(() {
            _isLoading = false;
            _isFetching = false;
          });
          throw Exception('Invalid data structure');
        }
      } else {
        setState(() {
          _isLoading = false;
          _isFetching = false;
        });
        print('Failed to load products');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isFetching = false;
      });
      print('Error fetching products: $e');
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

  // Handle category change
  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;  // Set selected category
      _allProducts.clear(); // Clear previous products before fetching new ones
      _currentPage = 1; // Reset to page 1
    });
    _fetchAllProducts();  // Fetch products based on selected category
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
                          _onCategorySelected(category);  // Select category
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

                        return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailProductPage(product: product),
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      CachedNetworkImage(
                                          imageUrl: imageUrl,  
                                          fit: BoxFit.cover,
                                          height: 150, 
                                          placeholder: (context, url) => const CircularProgressIndicator(), // Menampilkan loading indicator saat gambar dimuat
                                          errorWidget: (context, url, error) => const Icon(Icons.error), // Menampilkan icon error jika gagal memuat gambar
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
                                          formatPrice(product['harga_jual']),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green, // Harga sekarang berwarna hijau
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      },
                    ),
                  ),

            // Load More Button
            if (_hasMoreProducts)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _fetchAllProducts();  // Load more products
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Use the same color as category buttons
                    foregroundColor: Colors.white // Text color changes based on category selection
                  ),
                  child: const Text("Load More"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}