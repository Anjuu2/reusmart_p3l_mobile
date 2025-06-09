import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reusmart_mobile/client/PenitipClient.dart';
import 'package:reusmart_mobile/client/LoginClient.dart';
import 'package:reusmart_mobile/entity/Penitip.dart';
import 'package:reusmart_mobile/View/Login.dart';

class PenitipProfile extends StatefulWidget {
  final String namaPenitip;

  const PenitipProfile({Key? key, required this.namaPenitip}) : super(key: key);

  @override
  State<PenitipProfile> createState() => _PenitipProfileState();
}

class _PenitipProfileState extends State<PenitipProfile> {
  final _storage = const FlutterSecureStorage();
  final LoginClient _loginClient = LoginClient();
  final PenitipClient _penitipClient = PenitipClient();

  late Future<Penitip?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchPenitipProfile();
  }

  Future<Penitip?> _fetchPenitipProfile() async {
    final token = await _storage.read(key: 'api_token');
    debugPrint('Token dari storage: $token');

    if (token == null) return null;

    final result = await _penitipClient.getPenitipProfile(token);
    debugPrint('Hasil dari API: $result');

    if (result['success']) {
      return Penitip.fromJson(result['data']['penitip']);
    } else {
      return null;
    }
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
        title: const Text('Profil Penitip'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
      ),
      body: FutureBuilder<Penitip?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final penitip = snapshot.data!;
          final status = penitip.statusAktif != null && penitip.statusAktif! ? 'Aktif' : 'Nonaktif';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header profil
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
                        backgroundImage: AssetImage(
                          penitip.fotoKtp != null && penitip.fotoKtp!.isNotEmpty
                              ? penitip.fotoKtp! 
                              : 'assets/images/profile_placeholder.png',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        penitip.namaPenitip,
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

                _buildProfileField(Icons.email, 'Email', penitip.email),
                // _buildProfileField(Icons.phone, 'Telepon', penitip.notelp),
                _buildProfileField(Icons.credit_card, 'No. KTP', penitip.noKtp),
                _buildProfileField(Icons.person, 'Username', penitip.username),
                _buildProfileField(Icons.home, 'Alamat', penitip.alamat),
                _buildProfileField(Icons.monetization_on, 'Poin Anda', penitip.poin.toString()),
                _buildProfileField(Icons.account_balance_wallet, 'Saldo', penitip.saldoPenitip?.toString()),
                _buildRatingField(penitip.avgRating, penitip.countRating),
                _buildProfileField(Icons.verified_user, 'Status', penitip.statusAktif == true ? 'Aktif' : 'Nonaktif'),
              const SizedBox(height: 24),
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
    );
  }
}
