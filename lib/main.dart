import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Import semua halaman dashboard dan login
import 'package:reusmart_mobile/View/Login.dart';
import 'package:reusmart_mobile/View/Pembeli_Dashboard.dart';
import 'package:reusmart_mobile/View/Penitip_Profile.dart';
import 'package:reusmart_mobile/View/Kurir_Dashboard.dart';
import 'package:reusmart_mobile/View/Hunter_Dashboard.dart';
import 'package:reusmart_mobile/View/Homepage.dart';
import 'package:reusmart_mobile/View/BottomNav.dart';

// Background handler untuk Firebase Messaging
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // Pastikan Firebase diinisialisasi
  print("Handling a background message: ${message.messageId}");
}

// Pengaturan notifikasi lokal
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'default_channel', // ID channel harus sama dengan yang dipakai di FirebaseService backend
  'Default Channel',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

void setupFlutterNotifications() {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('bellfill');  // Ganti dengan nama icon Anda

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Inisialisasi Firebase

  setupFlutterNotifications();  // Setup notifikasi lokal

  // Meminta izin notifikasi
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Menangani pesan latar belakang
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Menangani pesan foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'bellfill',
          ),
        ),
      );
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReUseMart',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,   // Set warna AppBar
          foregroundColor: Colors.white,   // Set warna teks di AppBar
        ),
      ),
      home: MainNavPage(),  // Halaman utama saat aplikasi berjalan
      debugShowCheckedModeBanner: false,
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
              builder: (_) => PenitipProfile(
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
