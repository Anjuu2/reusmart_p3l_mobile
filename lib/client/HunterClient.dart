import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class HunterClient {
  static const String baseUrl = 'http://reusemart.shop/api';
  static const Duration timeoutDuration = Duration(seconds: 10);

  Future<Map<String, dynamic>> getHunterProfile(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/hunter-index'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'error': 'Gagal mengambil data Hunter.',
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

  Future<Map<String, dynamic>> getTotalKomisiHunter(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/hunter/komisi/total'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'error': 'Gagal mengambil data total komisi hunter.',
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

  Future<Map<String, dynamic>> getHistoryKomisiHunter(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/hunter-history-komisi'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'error': 'Gagal mengambil data history komisi.',
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

  Future<Map<String, dynamic>> getHistoryKomisiHunterLiveCode(
    String token, {
    int? month,
    int? year,
  }) async {
    try {
      String url = '$baseUrl//hunter-history-komisi-livecode';
      if (month != null && year != null) {
        url += '?month=$month&year=$year';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'error': 'Gagal mengambil data history komisi.',
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

  
}
