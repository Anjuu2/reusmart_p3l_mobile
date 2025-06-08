import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:reusmart_mobile/entity/FotoBarang.dart';

class BarangTitipan {
  final int idBarang;
  final int idPenitip;
  final int idPegawai;
  final int? idHunter;
  final int idKategori;
  final DateTime? tanggalMasuk;
  final DateTime? tanggalKeluar;
  final bool statusPerpanjangan;
  final String namaBarang;
  final double? hargaJual;
  final String? deskripsi;
  final List<FotoBarang> fotoBarang;
  final String? statusBarang;
  final bool? garansi;
  final DateTime? tanggalGaransi;
  final bool? barangHunter;
  final double? berat;
  final int? idNota;

  BarangTitipan({
    required this.idBarang,
    required this.idPenitip,
    required this.idPegawai,
    this.idHunter,
    required this.idKategori,
    this.tanggalMasuk,
    this.tanggalKeluar,
    required this.statusPerpanjangan,
    required this.namaBarang,
    this.hargaJual,
    this.deskripsi,
    required this.fotoBarang,
    this.statusBarang,
    this.garansi,
    this.tanggalGaransi,
    this.barangHunter,
    this.berat,
    this.idNota,
  });

  /// Helper: safe parse int from int or String
  static int? tryParseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  /// Helper: safe parse double from num or String
  static double? tryParseDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  /// Helper: safe parse bool from bool, 0/1, "true"/"false"
  static bool? tryParseBool(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is int) return v != 0;
    if (v is String) {
      final lower = v.toLowerCase();
      if (lower == 'true' || lower == '1') return true;
      if (lower == 'false' || lower == '0') return false;
    }
    return null;
  }

  /// Helper: safe parse DateTime from String
  static DateTime? tryParseDate(dynamic v) {
    if (v == null) return null;
    try {
      return DateTime.parse(v.toString());
    } catch (_) {
      return null;
    }
  }

  factory BarangTitipan.fromJson(Map<String, dynamic> json) {
    // Parse list foto_barang
    final fotosJson = json['foto_barang'] as List<dynamic>?;
    final listFotos = fotosJson != null
        ? fotosJson
            .map((e) => FotoBarang.fromJson(e as Map<String, dynamic>))
            .toList()
        : <FotoBarang>[];

    return BarangTitipan(
      // dua field wajib:
      idBarang: json['id_barang'] as int,
      idPenitip: json['id_penitip'] as int,
      idPegawai: tryParseInt(json['id_pegawai']) ?? 0,
      idHunter: tryParseInt(json['id_hunter']),
      idKategori: tryParseInt(json['id_kategori']) ?? 0,
      tanggalMasuk: tryParseDate(json['tanggal_masuk']),
      tanggalKeluar: tryParseDate(json['tanggal_keluar']),
      statusPerpanjangan:
          tryParseBool(json['status_perpanjangan']) ?? false,
      namaBarang: json['nama_barang'] as String? ?? '',
      hargaJual: tryParseDouble(json['harga_jual']),
      deskripsi: json['deskripsi'] as String? ?? '',
      fotoBarang: listFotos,
      statusBarang: json['status_barang'] as String? ?? '',
      garansi: tryParseBool(json['garansi']),
      tanggalGaransi: tryParseDate(json['tanggal_garansi']),
      barangHunter: tryParseBool(json['barang_hunter']),
      berat: tryParseDouble(json['berat']),
      idNota: tryParseInt(json['id_nota']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id_barang': idBarang,
        'id_penitip': idPenitip,
        'id_pegawai': idPegawai,
        'id_hunter': idHunter,
        'id_kategori': idKategori,
        'tanggal_masuk': tanggalMasuk?.toIso8601String(),
        'tanggal_keluar': tanggalKeluar?.toIso8601String(),
        'status_perpanjangan': statusPerpanjangan,
        'nama_barang': namaBarang,
        'harga_jual': hargaJual,
        'deskripsi': deskripsi,
        'foto_barang': fotoBarang.map((f) => f.toJson()).toList(),
        'status_barang': statusBarang,
        'garansi': garansi,
        'tanggal_garansi': tanggalGaransi?.toIso8601String(),
        'barang_hunter': barangHunter,
        'berat': berat,
        'id_nota': idNota,
      };

  String toJsonString() => json.encode(toJson());
}
