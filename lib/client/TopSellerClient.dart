import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reusmart_mobile/entity/TopSeller.dart';              
import 'package:reusmart_mobile/entity/Penitip.dart';   

class TopSellerClient {
  static const String baseUrl = 'http://reusemart.shop/api';

  final String token;
  TopSellerClient({required this.token});

  // 1. Ambil Top Seller Bulan Ini
  Future<TopSeller?> fetchTopSeller() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/top-seller'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return TopSeller.fromJson(data);
      } else {
        print('Fetch failed: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception during fetchTopSeller: $e');
      return null;
    }
  }

}
