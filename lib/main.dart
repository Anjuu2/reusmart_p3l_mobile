import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Import semua halaman dashboard dan login
import 'package:reusmart_mobile/View/Login.dart';
import 'package:reusmart_mobile/View/Pembeli_Dashboard.dart';
import 'package:reusmart_mobile/View/Penitip_Dashboard.dart';
import 'package:reusmart_mobile/View/Kurir_Dashboard.dart';
import 'package:reusmart_mobile/View/Hunter_Dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final Map<String, WidgetBuilder> staticRoutes = {
    '/': (context) => const LoginPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReUseMart',
      theme: ThemeData(primarySwatch: Colors.green),
      routes: staticRoutes,
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>? ?? {};

        switch (settings.name) {
          case '/pembeliDashboard':
            return MaterialPageRoute(
              builder: (_) => PembeliDashboard(
                namaPembeli: args['nama_pembeli'] ?? 'User',
              ),
            );
          case '/penitipDashboard':
            return MaterialPageRoute(
              builder: (_) => PenitipDashboard(
                namaPenitip: args['nama_penitip'] ?? 'User',
              ),
            );
          case '/kurirDashboard':
            return MaterialPageRoute(
              builder: (_) => KurirDashboard(
                namaKurir: args['nama_pegawai'] ?? 'User',
              ),
            );
          case '/hunterDashboard':
            return MaterialPageRoute(
              builder: (_) => HunterDashboard(
                namaHunter: args['nama_pegawai'] ?? 'User',
              ),
            );
          default:
            return null; // Bisa buat halaman 404 di sini
        }
      },
    );
  }
}
