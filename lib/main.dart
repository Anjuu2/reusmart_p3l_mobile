import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Import semua halaman dashboard
import 'package:reusmart_mobile/View/Login.dart';
import 'package:reusmart_mobile/View/Pembeli_Dashboard.dart';
import 'package:reusmart_mobile/View/Penitip_Dashboard.dart';
import 'package:reusmart_mobile/View/Kurir_Dashboard.dart';
import 'package:reusmart_mobile/View/Hunter_Dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _firebaseInit = Firebase.initializeApp();

  // Routes statis yang tidak perlu argumen
  final Map<String, WidgetBuilder> staticRoutes = {
    '/': (context) => LoginPage(),
  };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: _firebaseInit,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Firebase initialization error: ${snapshot.error}'),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
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
                  return null; // Bisa buat halaman 404 jika mau
              }
            },
          );
        }

        return MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
