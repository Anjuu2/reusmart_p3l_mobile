import 'package:flutter/material.dart';
import 'package:reusmart_mobile/client/LoginClient.dart';
import 'package:reusmart_mobile/View/BottomNav.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  String? _selectedUserType;
  bool _isLoading = false;
  String _errorMessage = '';

  final List<String> _userTypes = ['pembeli', 'penitip', 'kurir', 'hunter'];

  Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> saveFcmTokenToServer(String fcmToken, String apiToken, String userType) async {
    String url = '';
    if (userType == 'pembeli') {
      url = 'http://10.0.2.2:8000/api/save-fcm-token-pembeli';
    } else if (userType == 'penitip') {
      url = 'http://10.0.2.2:8000/api/save-fcm-token-penitip';
    } else if (userType == 'kurir') {
      url = 'http://10.0.2.2:8000/api/save-fcm-token-pegawai';
    } else {
      print('User type tidak dikenali');
      return;
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiToken',
      },
      body: jsonEncode({'fcm_token': fcmToken}),
    );

    if (response.statusCode == 200) {
      print('FCM token saved');
    } else {
      print('Failed to save FCM token: ${response.statusCode}');
    }
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      print("Form tidak valid atau currentState null");
      return;
    }
    if (_selectedUserType == null) {
      setState(() {
        _errorMessage = 'Pilih tipe user terlebih dahulu.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      LoginClient loginClient = LoginClient();
      var response = await loginClient.login(
        _emailController.text.trim(),
        _passwordController.text,
        _selectedUserType!.toLowerCase(),
      );

      print('Response login: $response');

      if (response == null) {
        setState(() {
          _errorMessage = 'Tidak ada response dari server.';
        });
        return;
      }

      if (response['success'] == true) {
        String apiToken = response['token'];

        // Simpan API Token di secure storage
        await _storage.write(key: 'api_token', value: apiToken);
        print("API Token disimpan di secure storage.");
        
        if (response['user']['id_pembeli'] != null) {
          String idPembeli = response['user']['id_pembeli'].toString();
          await _storage.write(key: 'id_pembeli', value: idPembeli);
          print("ID Pembeli disimpan di secure storage: $idPembeli");
        }

        String? fcmToken = await getFcmToken();
        String userType = _selectedUserType!.toLowerCase();
        print("API Token: $apiToken");
        print("FCM Token: $fcmToken");

        if (fcmToken != null) {
          await saveFcmTokenToServer(fcmToken, apiToken, userType);
        }

        if (response['user'] == null || response['user']['email'] == null) {
          setState(() {
            _errorMessage = 'Data user tidak lengkap dari server.';
          });
          return;
        }

        String email = response['user']['email'];
        String namaUser = email.split('@')[0];

        String? redirectPage = response['redirect_page'];
        if (redirectPage == null) {
          setState(() {
            _errorMessage = 'Redirect page tidak tersedia.';
          });
          return;
        }

        switch (redirectPage) {
          case 'dashboard.pembeli':
            Navigator.pushReplacementNamed(
              context,
              '/pembeliDashboard',
              arguments: {'nama_pembeli': namaUser},
            );
            break;
          case 'dashboard.penitip':
            Navigator.pushReplacementNamed(
              context,
              '/penitipDashboard',
              arguments: {'nama_penitip': namaUser},
            );
            break;
          case 'dashboard.kurir':
            Navigator.pushReplacementNamed(
              context,
              '/kurirDashboard',
              arguments: {'nama_pegawai': namaUser},
            );
            break;
          case 'dashboard.hunter':
            Navigator.pushReplacementNamed(
              context,
              '/hunterDashboard',
              arguments: {'nama_pegawai': namaUser},
            );
            break;
          default:
            Navigator.pushReplacementNamed(context, '/');
            break;
        }
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Login gagal. Periksa email dan password.';
        });
      }
    } catch (e, stack) {
      print("Exception saat login: $e");
      print(stack);
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login'),
          leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainNavPage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedUserType,
                decoration: const InputDecoration(
                  labelText: 'Tipe User',
                  border: OutlineInputBorder(),
                ),
                items: _userTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type[0].toUpperCase() + type.substring(1)),
                  );
                }).toList(),
                onChanged: _isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _selectedUserType = value;
                        });
                      },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih tipe user';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                enabled: !_isLoading,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
