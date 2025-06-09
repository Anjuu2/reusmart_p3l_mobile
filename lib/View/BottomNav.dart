import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:reusmart_mobile/View/HomePage.dart';         
import 'package:reusmart_mobile/View/Merchandise.dart';        
import 'package:reusmart_mobile/View/Login.dart';              
import 'package:reusmart_mobile/View/Pembeli_Profile.dart';   
import 'package:reusmart_mobile/View/Penitip_Profile.dart';   
import 'package:reusmart_mobile/View/Penitip_History.dart';   
import 'package:reusmart_mobile/View/Profile.dart';          

class MainNavPage extends StatefulWidget {
  const MainNavPage({Key? key}) : super(key: key);

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  int _currentIndex = 0;
  String _role = 'guest';
  final _storage = const FlutterSecureStorage();
  String? _namaUser;
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final token = await _storage.read(key: 'api_token');
    final role = await _storage.read(key: 'role');
    final nama = await _storage.read(key: 'nama_user');

    setState(() {
      _role = token == null ? 'guest' : (role ?? 'guest');
      _namaUser = nama;
      _isLoading = false;
    });
  }

  /// Semua halaman CONTENT (tanpa Scaffold)
  List<Widget> get _pages {
    switch (_role) {
      case 'penitip':
        return [
          PenitipProfile(namaPenitip: _namaUser ?? ''),
          PenitipHistoryPage(),
        ];
      case 'pembeli':
        return [
          HomePage(),
          MerchandisePage(),
          PembeliProfile(namaPembeli: _namaUser ?? ''),
        ];
      default:
        return [
          HomePage(),
          LoginPage(),
        ];
    }
  }

  /// Item di BottomNavigationBar sesuai role
  List<BottomNavigationBarItem> get _navItems {
    switch (_role) {
      case 'penitip':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ];
      case 'pembeli':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Merchandise'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ];
      default:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Login'),
        ];
    }
  }

  /// Judul AppBar dinamis
  // String get _appBarTitle {
  //   switch (_role) {
  //     case 'pembeli':
  //       if (_currentIndex == 0) return 'Home';
  //       if (_currentIndex == 1) return 'Merchandise';
  //       return 'Profil';
  //     case 'penitip':
  //       return _currentIndex == 0 ? 'Profil Penitip' : 'Riwayat Penitipan';
  //     default:
  //       return _currentIndex == 0 ? 'Home' : 'Login';
  //   }
  // }

  // void _onTabTapped(int idx) {
  //   // untuk guest, tapping profile (idx=1) tidak ganti tab, tapi tetap di tab 1 (LoginContent)
  //   setState(() {
  //     _currentIndex = idx;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final pages = _pages;
    final items = _navItems;

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) {
          setState(() => _currentIndex = idx);
        },
        items: items,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
