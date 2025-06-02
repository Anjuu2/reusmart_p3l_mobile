import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Import semua halaman dashboard
import 'package:reusmart_mobile/View/Login.dart';
import 'package:reusmart_mobile/View/Pembeli_Dashboard.dart';
import 'package:reusmart_mobile/View/Penitip_Dashboard.dart';
import 'package:reusmart_mobile/View/Kurir_Dashboard.dart';
import 'package:reusmart_mobile/View/Hunter_Dashboard.dart';

// Import halaman profil
import 'package:reusmart_mobile/View/Pembeli_profile.dart';
import 'package:reusmart_mobile/View/Penitip_profile.dart';
import 'package:reusmart_mobile/View/Kurir_profile.dart';
import 'package:reusmart_mobile/View/Hunter_profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReUseMart',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),

        // Dashboard tanpa parameter karena BottomNavigationBar yang tangani profil
        '/pembeliDashboard': (context) => PembeliDashboard(),
        '/penitipDashboard': (context) => PenitipDashboard(),
        '/kurirDashboard': (context) => KurirDashboard(),
        '/hunterDashboard': (context) => HunterDashboard(),
      },
    );
  }
}
