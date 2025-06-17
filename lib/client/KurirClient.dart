import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class KurirClient {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const Duration timeoutDuration = Duration(seconds: 60);

  Future<Map<String, dynamic>> getKurirProfile(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/kurir/index'),
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

  /// Ambil history pengiriman kurir dengan status 'Sampai'
  Future<Map<String, dynamic>> getKurirHistoryPengiriman(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/kurir/historyPengiriman'),
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
          'error': 'Gagal mengambil history pengiriman.',
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

  Future<Map<String, dynamic>> getKurirPengiriman(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/kurir/showPengiriman'),
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
          'error': 'Gagal mengambil data pengiriman.',
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

  Future<Map<String, dynamic>> getDetailPengiriman(String token, String idPengiriman) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/kurir/showPengiriman/detail/$idPengiriman'),
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
          'error': 'Gagal mengambil detail pengiriman.',
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

  Future<Map<String, dynamic>> konfirmasiPengiriman(String token, String idPengiriman) async {
    try {
      final response = await http
          .patch(
            Uri.parse('$baseUrl/kurir/konfirmasiPengiriman/$idPengiriman'),
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
          'error': 'Gagal konfirmasi pengiriman.',
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
