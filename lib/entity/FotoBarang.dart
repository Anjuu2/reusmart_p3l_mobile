import 'dart:convert';

class FotoBarang {
  final int idFoto;
  final int idBarang;
  final String namaFile;
  final int urutan;

  FotoBarang({
    required this.idFoto,
    required this.idBarang,
    required this.namaFile,
    required this.urutan,
  });

  /// Helper untuk konversi dinamis ke int
  static int tryParseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory FotoBarang.fromJson(Map<String, dynamic> json) {
    return FotoBarang(
      idFoto: tryParseInt(json['id_foto']),
      idBarang: tryParseInt(json['id_barang']),
      namaFile: json['nama_file'] ?? '',
      urutan: tryParseInt(json['urutan']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_foto': idFoto,
      'id_barang': idBarang,
      'nama_file': namaFile,
      'urutan': urutan,
    };
  }
}