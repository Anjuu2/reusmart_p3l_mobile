import 'package:flutter/material.dart';
import 'package:reusmart_mobile/client/LoginClient.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedUserType;

  bool _isLoading = false;
  String _errorMessage = '';

  final List<String> _userTypes = ['pembeli', 'penitip', 'kurir', 'hunter'];

  void _login() async {
    if (_selectedUserType == null) {
      setState(() {
        _errorMessage = 'Pilih tipe user terlebih dahulu.';
      });
      return;
    }
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Email dan password tidak boleh kosong.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    LoginClient loginClient = LoginClient();
    var response = await loginClient.login(
      _emailController.text.trim(),
      _passwordController.text,
      _selectedUserType!, // sudah lowercase di LoginClient
    );

    setState(() {
      _isLoading = false;
    });

    print('Response login: $response'); // Debug: lihat data dari server

    if (response['success'] == true) {
      // Cek apakah user ada dan email tersedia
      if (response['user'] != null && response['user']['email'] != null) {
        String email = response['user']['email'];

        String extractNameFromEmail(String email) {
          if (email.contains('@')) {
            return email.split('@')[0];
          }
          return email;
        }

        String namaUser = extractNameFromEmail(email);
        String redirectPage = response['redirect_page'];

        if (redirectPage == 'dashboard.pembeli') {
          Navigator.pushReplacementNamed(
            context,
            '/pembeliDashboard',
            arguments: {'nama_pembeli': namaUser},
          );
        } else if (redirectPage == 'dashboard.penitip') {
          Navigator.pushReplacementNamed(
            context,
            '/penitipDashboard',
            arguments: {'nama_penitip': namaUser},
          );
        } else if (redirectPage == 'dashboard.kurir') {
          Navigator.pushReplacementNamed(
            context,
            '/kurirDashboard',
            arguments: {'nama_pegawai': namaUser},
          );
        } else if (redirectPage == 'dashboard.hunter') {
          Navigator.pushReplacementNamed(
            context,
            '/hunterDashboard',
            arguments: {'nama_pegawai': namaUser},
          );
        } else {
          Navigator.pushReplacementNamed(context, '/');
        }
      } else {
        setState(() {
          _errorMessage = 'Data user tidak lengkap dari server.';
        });
      }
    } else {
      // Tampilkan pesan error dari server atau pesan default
      setState(() {
        _errorMessage = response['message'] ?? 'Login gagal. Periksa email dan password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedUserType,
              decoration: InputDecoration(
                labelText: 'Tipe User',
                border: OutlineInputBorder(),
              ),
              items: _userTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type[0].toUpperCase() + type.substring(1)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUserType = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
