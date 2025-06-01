import 'dart:convert';

class Pegawai {
  int id_pegawai;
  int id_jabatan;
  String nama_pegawai;
  String email;
  String notelp;
  String password; // Menambahkan field password
  bool status_aktif; // Menambahkan field status_aktif
  String tanggal_lahir; // Menambahkan field tanggal_lahir dengan tipe String (format date)

  Pegawai({
    required this.id_pegawai,
    required this.nama_pegawai,
    required this.email,
    required this.id_jabatan,
    required this.notelp,
    required this.password,
    required this.status_aktif,
    required this.tanggal_lahir,
  });

  // Method untuk membuat objek Pegawai dari raw JSON
  factory Pegawai.fromRawJson(String str) => Pegawai.fromJson(json.decode(str));

  // Method untuk membuat objek Pegawai dari Map
  factory Pegawai.fromJson(Map<String, dynamic> json) => Pegawai(
        id_pegawai: json["id_pegawai"],
        nama_pegawai: json["nama_pegawai"],
        email: json["email"],
        id_jabatan: json["id_jabatan"],
        notelp: json["no_telp"],
        password: json["password"],
        status_aktif: json["status_aktif"],
        tanggal_lahir: json["tanggal_lahir"], // Mengambil tanggal_lahir dari JSON
      );

  // Mengubah objek Pegawai ke format JSON
  String toRawJson() => json.encode(toJson());

  // Mengubah objek Pegawai ke Map
  Map<String, dynamic> toJson() => {
        "id_pegawai": id_pegawai,
        "nama_pegawai": nama_pegawai,
        "email": email,
        "id_jabatan": id_jabatan,
        "no_telp": notelp,
        "password": password,
        "status_aktif": status_aktif,
        "tanggal_lahir": tanggal_lahir, // Menyimpan tanggal_lahir ke dalam Map
      };
}
