import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reusmart_mobile/View/LiveCoding.dart';
import 'package:reusmart_mobile/client/HunterClient.dart';
import 'package:reusmart_mobile/client/LoginClient.dart';
import 'package:reusmart_mobile/View/Hunter_Dashboard.dart';
import 'package:reusmart_mobile/View/HunterHistoryPage.dart';
// import 'package:reusmart_mobile/View/Hunter_History.dart';
import 'package:reusmart_mobile/View/Login.dart';

class HunterProfile extends StatefulWidget {
  final String namaHunter;

  const HunterProfile({Key? key, required this.namaHunter}) : super(key: key);

  @override
  State<HunterProfile> createState() => _HunterProfileState();
}

class _HunterProfileState extends State<HunterProfile> {
  final HunterClient _HunterClient = HunterClient();
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

    final profileResult = await _HunterClient.getHunterProfile(token);
    if (profileResult['success'] == false) {
      return profileResult;
    }

    final komisiResult = await _HunterClient.getTotalKomisiHunter(token);
    if (komisiResult['success'] == false) {
      // Jika gagal, set komisi ke 0 agar tidak error
      profileResult['data']['total_komisi'] = 0;
    } else {
      profileResult['data']['total_komisi'] =
          komisiResult['data']['total_komisi_hunter'] ?? 0;
    }

    return profileResult;
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
        MaterialPageRoute(builder: (_) => const LoginPage()), // Ganti dengan halaman login
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
        title: const Text('Profil Hunter'),
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
          final nama = profile['nama_pegawai'] ?? '-';
          final username = profile['username'] ?? '-';
          final email = profile['email'] ?? '-';
          final notelp = profile['notelp'] ?? '-';
          final status = 'Aktif'; // Asumsi aktif, ubah sesuai logic backend
          final komisi = profile['total_komisi'] != null
                          ? 'Rp ${profile['total_komisi']}'.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')
                          : '-';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header dengan foto profil bulat
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
                       backgroundImage: const NetworkImage('https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541'),
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

                // Field dengan icon
                _buildProfileField(Icons.phone, 'Nomor Telepon', notelp),
                _buildProfileField(Icons.verified_user, 'Status Akun', status),
                _buildProfileField(Icons.email, 'Email', email),
                _buildProfileField(Icons.account_balance_wallet, 'Jumlah Komisi', komisi),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HunterHistoryPage(), 
                      ),
                    );
                  },
                  icon: const Icon(Icons.work_history, color: Colors.white),
                  label: const Text('History Komisi', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Tombol Logout
                ElevatedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Logout', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Tombol merah
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // index 1 karena ini halaman profil
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HunterDashboard(namaHunter: widget.namaHunter),
              ),
            );
          }
        },
      ),
    );
  }
}