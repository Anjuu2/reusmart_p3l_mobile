class Badge {
  final int idBadge;
  final int idPenitip;
  final String namaBadge;
  final DateTime periodePemberian;

  Badge({
    required this.idBadge,
    required this.idPenitip,
    required this.namaBadge,
    required this.periodePemberian,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      idBadge: json['id_badge'],
      idPenitip: json['id_penitip'],
      namaBadge: json['nama_badge'],
      periodePemberian: DateTime.parse(json['periode_pemberian']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_badge': idBadge,
      'id_penitip': idPenitip,
      'nama_badge': namaBadge,
      'periode_pemberian': periodePemberian.toIso8601String(),
    };
  }
}
