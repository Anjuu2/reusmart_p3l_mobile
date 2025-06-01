import 'dart:convert';

class Penitip {
  int id_penitip;
  String nama_penitip;
  String email;
  String notelp;
  String alamat;
  double saldo_penitip;
  String no_ktp;         // Menambahkan field no_ktp
  String username;       // Menambahkan field username
  String password;       // Menambahkan field password
  String foto_ktp;       // Menambahkan field foto_ktp
  bool status_aktif;     // Menambahkan field status_aktif (boolean)

  Penitip({
    required this.id_penitip,
    required this.nama_penitip,
    required this.email,
    required this.notelp,
    required this.alamat,
    required this.saldo_penitip,
    required this.no_ktp,
    required this.username,
    required this.password,
    required this.foto_ktp,
    required this.status_aktif,
  });

  // Method untuk membuat objek Penitip dari raw JSON
  factory Penitip.fromRawJson(String str) => Penitip.fromJson(json.decode(str));

  // Method untuk membuat objek Penitip dari Map
  factory Penitip.fromJson(Map<String, dynamic> json) => Penitip(
        id_penitip: json["id_penitip"],
        nama_penitip: json["nama_penitip"],
        email: json["email"],
        notelp: json["no_telp"],
        alamat: json["alamat"],
        saldo_penitip: json["saldo_penitip"].toDouble(),
        no_ktp: json["no_ktp"],   // Mengambil no_ktp dari JSON
        username: json["username"],   // Mengambil username dari JSON
        password: json["password"],   // Mengambil password dari JSON
        foto_ktp: json["foto_ktp"],   // Mengambil foto_ktp dari JSON
        status_aktif: json["status_aktif"],   // Mengambil status_aktif dari JSON
      );

  // Mengubah objek Penitip ke format JSON
  String toRawJson() => json.encode(toJson());

  // Mengubah objek Penitip ke Map
  Map<String, dynamic> toJson() => {
        "id_penitip": id_penitip,
        "nama_penitip": nama_penitip,
        "email": email,
        "no_telp": notelp,
        "alamat": alamat,
        "saldo_penitip": saldo_penitip,
        "no_ktp": no_ktp,        // Menyimpan no_ktp ke dalam Map
        "username": username,    // Menyimpan username ke dalam Map
        "password": password,    // Menyimpan password ke dalam Map
        "foto_ktp": foto_ktp,    // Menyimpan foto_ktp ke dalam Map
        "status_aktif": status_aktif,  // Menyimpan status_aktif ke dalam Map
      };
}
