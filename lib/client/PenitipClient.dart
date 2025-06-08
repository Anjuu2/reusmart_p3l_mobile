import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class PenitipClient {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const Duration timeoutDuration = Duration(seconds: 10);

  /// Ambil profil penitip
  Future<Map<String, dynamic>> getPenitipProfile(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/penitip-index'),
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
  Future<Map<String, dynamic>> getPenitipHistoryTitipan(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/penitip/historyTitipan'),
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
          'error': 'Gagal mengambil history titipan.',
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
