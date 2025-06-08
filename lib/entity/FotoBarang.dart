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

  factory FotoBarang.fromJson(Map<String, dynamic> json) {
    return FotoBarang(
      idFoto: json['id_foto'] as int,
      idBarang: json['id_barang'] as int,
      namaFile: json['nama_file'] as String,
      urutan: json['urutan'] as int,
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