import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class KurirClient {
  // URL base API, sesuaikan dengan environmentmu
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Timeout durasi untuk request HTTP
  static const Duration timeoutDuration = Duration(seconds: 10);

  /// Ambil data kurir yang sedang login dari API
  /// Token harus diberikan agar bisa autentikasi
  Future<Map<String, dynamic>> getKurirProfile(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/kurir-index'),
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
          'error': 'Gagal mengambil data kurir.',
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
