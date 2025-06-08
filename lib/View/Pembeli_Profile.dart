import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reusmart_mobile/client/PembeliClient.dart';
import 'package:reusmart_mobile/client/LoginClient.dart';
import 'package:reusmart_mobile/View/Pembeli_Dashboard.dart';
import 'package:reusmart_mobile/View/Merchandise.dart';
import 'package:reusmart_mobile/View/Login.dart';

class PembeliProfile extends StatefulWidget {
  final String namaPembeli;

  const PembeliProfile({Key? key, required this.namaPembeli}) : super(key: key);

  @override
  State<PembeliProfile> createState() => _PembeliProfileState();
}

class _PembeliProfileState extends State<PembeliProfile> {
  final PembeliClient _pembeliClient = PembeliClient();
  final LoginClient _loginClient = LoginClient();
  final _storage = const FlutterSecureStorage();

  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchProfile();
  }

  Future<Map<String, dynamic>> _fetchProfile() async {
    String? token = await _storage.read(key: 'api_token');
    if (token == null) {
      return {'success': false, 'error': 'Token tidak tersedia.'};
    }
    return await _pembeliClient.getPembeliProfile(token);
  }

  Future<void> _handleLogout() async {
    final token = await _storage.read(key: 'api_token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token tidak ditemukan.')),
      );
      return;
    }

    final result = await _loginClient.logout(token);
    if (result['success']) {
      await _storage.delete(key: 'api_token');
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Logout gagal.')),
      );
    }
  }

  Widget _buildProfileField(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromRGBO(0, 128, 0, 0.7)),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Profil Pembeli'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          if (data['success'] == false) {
            return Center(child: Text('Error: ${data['error']}'));
          }

          final profile = data['data'];
          final nama = profile['nama_pembeli'] ?? '-';
          final username = profile['username'] ?? '-';
          final email = profile['email'] ?? '-';
          final notelp = profile['notelp'] ?? '-';
          final status = profile['status_aktif'] ? 'Aktif' : 'Tidak Aktif';
          final poin = profile['poin']?.toString() ?? '0';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 128, 0, 0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: const AssetImage('assets/images/profile_placeholder.png'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        nama,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildProfileField(Icons.phone, 'Nomor Telepon', notelp),
                _buildProfileField(Icons.verified_user, 'Status Akun', status),
                _buildProfileField(Icons.email, 'Email', email),
                _buildProfileField(Icons.monetization_on, 'Poin Anda', poin),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Logout', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Merchandise',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PembeliDashboard(namaPembeli: widget.namaPembeli),
              ),
            );
          } else if (index == 1){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MerchandisePage(namaPembeli: widget.namaPembeli),
              ),
            );
          }
        },
      ),
    );
  }
}
