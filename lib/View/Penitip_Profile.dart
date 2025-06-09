import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reusmart_mobile/client/PenitipClient.dart';
import 'package:reusmart_mobile/entity/Penitip.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reusmart_mobile/View/Login.dart';
import 'package:reusmart_mobile/View/BottomNav.dart';
import 'package:reusmart_mobile/client/LoginClient.dart';

class PenitipProfile extends StatefulWidget {
  final String namaPenitip;

  const PenitipProfile({Key? key, required this.namaPenitip}) : super(key: key);

  @override
  State<PenitipProfile> createState() => _PenitipProfileState();
}

class _PenitipProfileState extends State<PenitipProfile> {
  final _storage = const FlutterSecureStorage();
  final PenitipClient _penitipClient = PenitipClient();
  final LoginClient _loginClient = LoginClient();

  // static const String baseUrl = 'http://10.0.2.2:8000/api';

  late Future<Penitip?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchPenitipProfile();
  }

  Future<Penitip?> _fetchPenitipProfile() async {
    final token = await _storage.read(key: 'api_token');
    if (token == null) return null;

    final result = await _penitipClient.getPenitipProfile(token);
    if (result['success'] == true && result['data']?['penitip'] != null) {
      final Map<String, dynamic> penitipMap = Map<String, dynamic>.from(result['data']['penitip']);
      penitipMap['avgRating'] = result['data']['avgRating'];
      penitipMap['countRating'] = result['data']['countRating'];
      return Penitip.fromJson(penitipMap);
    }
    return null;
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah kamu yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // batal logout
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true), // konfirmasi logout
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await _handleLogout();
    }
  }

  Future<void> _handleLogout() async {
    final token = await _storage.read(key: 'api_token');
    if (token == null) return;
    final result = await _loginClient.logout(token);
    if (result['success'] == true) {
      await _storage.delete(key: 'api_token');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => MainNavPage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Logout gagal.')),
      );
    }
  }

  Widget _buildRatingField(double? avgRating, int? countRating) {
    final isRatingAvailable = avgRating != null && avgRating > 0;

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
        leading: const Icon(Icons.star, color: Color.fromRGBO(0, 128, 0, 0.7)),
        title: const Text('Rating Rata-rata', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          isRatingAvailable
              ? '${avgRating!.toStringAsFixed(2)} / 5.0'
              : 'Belum ada rating',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
  
  Widget _buildProfileField(IconData icon, String label, String? value) {
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
        subtitle: Text(value ?? '-', style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        title: const Text('My Profile'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
      ),
      body: FutureBuilder<Penitip?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Gagal memuat profil penitip.'));
          }

          final penitip = snapshot.data!;

           // Handle null-safe fotoKtp
          final fotoPath = (penitip.fotoKtp != null && penitip.fotoKtp!.isNotEmpty)
              ? penitip.fotoKtp!
              : 'assets/images/profile_placeholder.png';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header dengan nama
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 128, 0, 0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(fotoPath),
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
                _buildProfileField(Icons.emoji_events, 'Poin', penitip.poin.toString()),
                _buildProfileField(Icons.account_balance_wallet, 'Saldo', penitip.saldoPenitip?.toString()),
                _buildRatingField(penitip.avgRating, penitip.countRating),
                _buildProfileField(Icons.verified_user, 'Status', penitip.statusAktif == true ? 'Aktif' : 'Nonaktif'),
              const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _confirmLogout,
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