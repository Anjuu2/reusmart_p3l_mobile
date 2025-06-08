// model/kategori.dart

import 'dart:convert';

/// Model class for Kategori (Category)
class Kategori {
  final int idKategori;
  final String namaKategori;

  Kategori({
    required this.idKategori,
    required this.namaKategori,
  });

  /// Create a Kategori from JSON
  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      idKategori: (json['id_kategori'] ?? json['idKategori']) as int,
      namaKategori: (json['nama_kategori'] ?? json['namaKategori']) as String,
    );
  }

  /// Convert Kategori to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_kategori': idKategori,
      'nama_kategori': namaKategori,
    };
  }

  /// Utility: Convert object to JSON string
  String toJsonString() => json.encode(toJson());
}
