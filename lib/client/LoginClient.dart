import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginClient {
  // ini pake url buat emulator android studio, kalo pake yang lain ganti sendiri ya !!
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> login(String email, String password, String tipeUser) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email.trim(),
        'password': password,
        'tipe_user': tipeUser.toLowerCase(),  // Kirim tipe user lowercase
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'error': 'Email atau password salah.'};
    }
  }

  Future<Map<String, dynamic>> logout(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'error': 'Logout gagal. Coba lagi.'};
    }
  }
}