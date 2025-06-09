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
  final _storage = const FlutterSecureStorage();
  String _role = 'guest'; // 'guest', 'pembeli', 'penitip'
  int _currentIndex = 0;
  String? _namaUser;

  @override
  void initState() {
    super.initState();
    _determineRole();
  }

  Future<void> _determineRole() async {
    final token = await _storage.read(key: 'api_token');
    final role  = await _storage.read(key: 'role');
    final nama  = await _storage.read(key: 'nama_user');
    setState(() {
      _namaUser = nama;
      if (token == null) {
        _role = 'guest';
      } else if (role == 'penitip') {
        _role = 'penitip';
      } else if (role == 'pembeli') {
        _role = 'pembeli';
      } else {
        _role = 'guest';
      }
    });
  }

  /// Semua halaman CONTENT (tanpa Scaffold)
  List<Widget> get _pages {
    switch (_role) {
      case 'pembeli':
        return [
          HomePage(),
          MerchandisePage(namaPembeli: _namaUser ?? ''),
          PembeliProfile(namaPembeli: _namaUser ?? ''),
        ];
      case 'penitip':
        return [
          PenitipProfile(namaPenitip: _namaUser ?? ''),
          PenitipHistoryPage(),
        ];
      default: // guest
        return [
          HomePage(),
          LoginPage(),
        ];
    }
  }

  /// Item di BottomNavigationBar sesuai role
  List<BottomNavigationBarItem> get _navItems {
    switch (_role) {
      case 'pembeli':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Merchandise'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ];
      case 'penitip':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ];
      default:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ];
    }
  }

  /// Judul AppBar dinamis
  String get _appBarTitle {
    switch (_role) {
      case 'pembeli':
        if (_currentIndex == 0) return 'Home';
        if (_currentIndex == 1) return 'Merchandise';
        return 'Profil';
      case 'penitip':
        return _currentIndex == 0 ? 'Profil Penitip' : 'Riwayat Penitipan';
      default:
        return _currentIndex == 0 ? 'Home' : 'Login';
    }
  }

  void _onTabTapped(int idx) {
    // untuk guest, tapping profile (idx=1) tidak ganti tab, tapi tetap di tab 1 (LoginContent)
    setState(() {
      _currentIndex = idx;
    });
  }

    @override
    Widget build(BuildContext context) {
      final pages = _pages;       // List<Widget> content
      final items = _navItems; 
        if ((_role == 'guest' && _namaUser == null) || pages.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_appBarTitle),
      //   centerTitle: true,
      //   backgroundColor: const Color.fromRGBO(0, 128, 0, 0.7),
      // ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: items,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onTabTapped,
      ),
    );
  }
}