import 'package:flutter/material.dart';
import 'package:reusmart_mobile/client/LoginClient.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedUserType;

  bool _isLoading = false;
  String _errorMessage = '';

  final List<String> _userTypes = ['pembeli', 'penitip', 'kurir', 'hunter'];

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
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

      if (response['success'] == true) {
        if (response['user'] != null && response['user']['email'] != null) {
          String email = response['user']['email'];

          String extractNameFromEmail(String email) {
            if (email.contains('@')) {
              return email.split('@')[0];
            }
            return email;
          }

          String namaUser = extractNameFromEmail(email);
          String? redirectPage = response['redirect_page'];

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
            _errorMessage = 'Data user tidak lengkap dari server.';
          });
        }
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Login gagal. Periksa email dan password.';
        });
      }
    } catch (e) {
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
      appBar: AppBar(title: const Text('Login')),
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
