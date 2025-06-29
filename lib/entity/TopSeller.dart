class TopSeller {
  final int id;
  final int idPenitip;
  final String namaBadge;
  final String namaPenitip;
  final DateTime periode;
  final double bonus;
  final double totalPenjualan;

  TopSeller({
    required this.id,
    required this.idPenitip,
    required this.namaBadge,
    required this.namaPenitip,
    required this.periode,
    required this.bonus,
    required this.totalPenjualan,
  });

  factory TopSeller.fromJson(Map<String, dynamic> json) {
    print('Parsing TopSeller: $json');
    return TopSeller(
      id: json['id_badge'],
      idPenitip: json['id_penitip'],
      namaBadge: json['nama_badge'],
      namaPenitip: json['penitip']['nama_penitip'], // penting: ini nested
      periode: DateTime.tryParse(json['periode_pemberian']) ?? DateTime.now(),
      bonus: (json['bonus'] as num?)?.toDouble() ?? 0.0,
      totalPenjualan: (json['total_penjualan'] as num?)?.toDouble() ?? 0.0,
    );
  }

}
