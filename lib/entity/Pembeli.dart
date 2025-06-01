import 'dart:convert';

class Pembeli {
  int id;
  String nama_pembeli;
  String email;
  String notelp;
  String alamat;
  int poin;
  String username;      // Menambahkan field username
  String password;      // Menambahkan field password
  bool status_aktif;    // Menambahkan field status_aktif (boolean)

  Pembeli({
    required this.id,
    required this.nama_pembeli,
    required this.email,
    required this.notelp,
    required this.alamat,
    required this.poin,
    required this.username,
    required this.password,
    required this.status_aktif,
  });

  // Method untuk membuat objek Pembeli dari raw JSON
  factory Pembeli.fromRawJson(String str) => Pembeli.fromJson(json.decode(str));

  // Method untuk membuat objek Pembeli dari Map
  factory Pembeli.fromJson(Map<String, dynamic> json) => Pembeli(
        id: json["id"],
        nama_pembeli: json["nama_pembeli"],
        email: json["email"],
        notelp: json["no_telp"],
        alamat: json["alamat"],
        poin: json["poin"],
        username: json["username"],   // Mengambil username dari JSON
        password: json["password"],   // Mengambil password dari JSON
        status_aktif: json["status_aktif"],  // Mengambil status_aktif dari JSON
      );

  // Mengubah objek Pembeli ke format JSON
  String toRawJson() => json.encode(toJson());

  // Mengubah objek Pembeli ke Map
  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_pembeli": nama_pembeli,
        "email": email,
        "no_telp": notelp,
        "alamat": alamat,
        "poin": poin,
        "username": username,   // Menyimpan username ke dalam Map
        "password": password,   // Menyimpan password ke dalam Map
        "status_aktif": status_aktif,  // Menyimpan status_aktif ke dalam Map
      };
}
