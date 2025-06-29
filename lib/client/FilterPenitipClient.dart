import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class FilterPenitipClient{

  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const Duration timeoutDuration = Duration(seconds: 10);

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