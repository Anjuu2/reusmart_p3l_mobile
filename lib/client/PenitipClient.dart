import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;


class PenitipClient {
  static const String baseUrl = 'http://reusemart.shop/api';
  static const Duration timeoutDuration = Duration(seconds: 10);

  /// Ambil profil penitip
  Future<Map<String, dynamic>> getPenitipProfile(String token) async {
    try {
      final response = await http
        .get(
          Uri.parse('$baseUrl/penitip-index'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(timeoutDuration);
        
      print('🔥 RAW PROFILE JSON: ${response.body}');


      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'error': 'Gagal mengambil data penitip.',
          'statusCode': response.statusCode,
          'body': response.body,
        };
      }
    } on TimeoutException {
      return {'success': false, 'error': 'Request timeout. Coba lagi.'};
    } catch (e) {
      return {'success': false, 'error': 'Terjadi kesalahan: $e'};
    }
  }

  /// Ambil history barang yang pernah dititipkan penitip
  Future<Map<String, dynamic>> getPenitipHistoryTitipan(String token,
    {int page = 1, String? search, String? status}) async {
    final queryParams = {
      'page': page.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
      if (status != null && status.toLowerCase() != 'semua') 'status': status,
    };

    final uri = Uri.parse('$baseUrl/penitip-history').replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data['data'],
          'pagination': data['pagination'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Gagal memuat data riwayat.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
}