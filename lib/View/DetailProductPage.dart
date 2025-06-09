import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailProductPage extends StatelessWidget {
  final Map<String, dynamic> product;

  // Constructor untuk menerima data produk
  DetailProductPage({required this.product});

  @override
  Widget build(BuildContext context) {
    // URL gambar pertama dan kedua dari produk
    final imageUrl1 = 'http://10.0.2.2:8000/images/barang/${product['foto_barang'][0]['nama_file'] ?? 'default.jpg'}';
    final imageUrl2 = 'http://10.0.2.2:8000/images/barang/${product['foto_barang'][1]['nama_file'] ?? 'default.jpg'}';

    // List of images
    List<String> imageUrls = [imageUrl1, imageUrl2];

    // Controller untuk PageView
    final PageController _pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        title: Text(product['nama_barang'] ?? 'Detail Barang'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Slider Section
            Container(
              height: 250,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // When an image is tapped, open a full-screen view
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImagePage(imageUrl: imageUrls[index]),
                            ),
                          );
                        },
                        child: Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(imageUrls[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: imageUrls.length,
                        effect: WormEffect(
                          dotWidth: 8,
                          dotHeight: 8,
                          spacing: 4,
                          dotColor: Colors.white.withOpacity(0.5),
                          activeDotColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Product Name
            Text(
              product['nama_barang'] ?? 'Nama barang tidak tersedia',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),

            // Price Section
            Text(
              '${formatPrice(product['harga_jual'])}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),

            // Deskripsi Section without using Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deskripsi Produk',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      product['deskripsi'] ?? 'Deskripsi tidak tersedia',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.7),
                        height: 1.5, // Adjust line height for better readability
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Warranty Section
            if (product['garansi'] == true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Garansi: Tersedia hingga ${formatDate(product['tanggal_garansi'])}',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Garansi: Tidak Tersedia',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 16),

            // Weight Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.fitness_center, color: Colors.blue, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Berat: ${product['berat']} kg',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Function to format price as "Rp. 000.000.000"
  String formatPrice(int price) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return format.format(price);
  }

  // Function to format the date (garansi)
  String formatDate(String date) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    final DateTime parsedDate = DateTime.parse(date);
    return formatter.format(parsedDate);
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  FullScreenImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Gambar Penuh', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);  // Close the full-screen image view
          },
          child: InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: imageUrl,  // URL gambar yang ingin dimuat
              fit: BoxFit.contain, // Mengatur cara gambar ditampilkan
              placeholder: (context, url) => const CircularProgressIndicator(), // Menampilkan loading indicator saat gambar dimuat
              errorWidget: (context, url, error) => const Icon(Icons.error), // Menampilkan icon error jika gagal memuat gambar
            ),
          ),
        ),
      ),
    );
  }
}
