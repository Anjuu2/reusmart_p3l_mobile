import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class LoginClient {
  // URL untuk emulator Android Studio, ganti sesuai kebutuhan
  // static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const String baseUrl = 'http://192.168.54.79:8000/api';


  // Timeout durasi untuk request HTTP
  static const Duration timeoutDuration = Duration(seconds: 10);

  Future<Map<String, dynamic>> login(String email, String password, String tipeUser) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': email.trim(),
              'password': password,
              'tipe_user': tipeUser.toLowerCase(),
            }),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'error': 'Email atau password salah.',
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

  Future<Map<String, dynamic>> logout(String token) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/logout'),
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
          'error': 'Logout gagal. Coba lagi.',
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
