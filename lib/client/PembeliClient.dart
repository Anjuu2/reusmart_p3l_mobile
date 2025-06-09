import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class PembeliClient {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const Duration timeoutDuration = Duration(seconds: 10);

  Future<Map<String, dynamic>> getPembeliProfile(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/pembeli-profile'),
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
          'error': 'Gagal mengambil data Pembeli.',
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

  Future<Map<String, dynamic>> getMerchandiseList(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/merchandise'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data['data']};
      } else {
        return {
          'success': false,
          'error': 'Gagal mengambil data merchandise.',
          'statusCode': response.statusCode,
          'body': response.body,
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Terjadi kesalahan: $e'};
    }
  }

  Future<Map<String, dynamic>> claimMerchandise(String token, int idPembeli, int idMerchandise) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reward/claim-merchandise'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_pembeli': idPembeli,
          'id_merchandise': idMerchandise,
        }),
      ).timeout(timeoutDuration);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        // Tambahkan parsing error dari backend agar errornya lebih detail
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        return {
          'success': false,
          'error': errorResponse['error'] ?? 'Gagal klaim merchandise.',
          'statusCode': response.statusCode,
          'body': response.body,
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Terjadi kesalahan: $e'};
    }
  }

  Future<Map<String, dynamic>> getRewardHistory(String token, int idPembeli) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reward/history/$idPembeli'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'success': false,
          'error': 'Gagal mengambil riwayat klaim.',
          'statusCode': response.statusCode,
          'body': response.body,
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Terjadi kesalahan: $e'};
    }
  }

  Future<Map<String, dynamic>> getPembeliHistoryPembelian(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/pembeli-history'),
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
  
}
