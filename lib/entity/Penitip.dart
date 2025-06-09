import 'dart:convert';

class Penitip {
  final int idPenitip;
  final int? poin;
  final String namaPenitip;
  final String? email;
  // final String? notelp;
  final String? alamat;
  final double? saldoPenitip;
  final String? noKtp;
  final String? username;
  final String? password;
  final String? fotoKtp;
  final bool? statusAktif;
  final double? avgRating;
  final int? countRating;

  Penitip({
    required this.idPenitip,
    this.poin,
    required this.namaPenitip,
    this.email,
    // this.notelp,
    this.alamat,
    this.saldoPenitip,
    this.noKtp,
    this.username,
    this.password,
    this.fotoKtp,
    this.statusAktif,
    this.avgRating,
    this.countRating,
  });

  // Method untuk membuat objek Penitip dari raw JSON
  factory Penitip.fromRawJson(String str) => Penitip.fromJson(json.decode(str));

  // Method untuk membuat objek Penitip dari Map
  factory Penitip.fromJson(Map<String, dynamic> json) => Penitip(
    idPenitip: json['id_penitip'],
    poin: json['poin'] != null ? (json['poin'] as num).toInt() : null,
    namaPenitip: json['nama_penitip'],
    email: json['email'],
    // notelp: json['no_telp'],
    alamat: json['alamat'],
    saldoPenitip: (json['saldo_penitip'] != null) ? json['saldo_penitip'].toDouble() : null,
    noKtp: json['no_ktp'],
    username: json['username'],
    password: json['password'],
    fotoKtp: json['foto_ktp'],
    statusAktif: json['status_aktif'],
    avgRating: json['avgRating'] != null
        ? double.tryParse(json['avgRating'].toString()) ?? 0.0
        : 0.0,
    countRating: json['countRating'] != null
        ? int.tryParse(json['countRating'].toString()) ?? 0
        : 0,
  );

  // Mengubah objek Penitip ke format JSON
  String toRawJson() => json.encode(toJson());

  // Mengubah objek Penitip ke Map
  Map<String, dynamic> toJson() => {
        "id_penitip": idPenitip,
        "poin": poin,
        "nama_penitip": namaPenitip,
        "email": email,
        // "no_telp": notelp,
        "alamat": alamat,
        "saldo_penitip": saldoPenitip,
        "no_ktp": noKtp,       
        "username": username,   
        "password": password,   
        "foto_ktp": fotoKtp,   
        "status_aktif": statusAktif,
      };
}
