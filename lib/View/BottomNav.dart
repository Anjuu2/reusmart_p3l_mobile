import 'package:flutter/material.dart';
import 'package:reusmart_mobile/View/Homepage.dart';
import 'package:reusmart_mobile/View/Profile.dart';
import 'package:reusmart_mobile/View/Login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainNavPage extends StatefulWidget {
  @override
  _MainNavPageState createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  int _currentIndex = 0;
  bool _isLoggedIn = false;
  final _storage = const FlutterSecureStorage();
  final _pages = [
    HomePage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await _storage.read(key: 'api_token');
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (!_isLoggedIn) {
    //   return LoginPage(); 
    // }
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
       onTap: (idx) async {
        if (idx == 1) {
          await _checkLoginStatus();  
          if (!_isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
            return; 
          }
        }
        setState(() {
          _currentIndex = idx;
        });
      },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

