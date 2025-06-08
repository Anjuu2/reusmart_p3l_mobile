class RatingModel {
  final int idRating;
  final int idPenitip;
  final int idBarang;
  final int idPembeli;
  final int rating;

  RatingModel({
    required this.idRating,
    required this.idPenitip,
    required this.idBarang,
    required this.idPembeli,
    required this.rating,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      idRating: json['id_rating'],
      idPenitip: json['id_penitip'],
      idBarang: json['id_barang'],
      idPembeli: json['id_pembeli'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_rating': idRating,
      'id_penitip': idPenitip,
      'id_barang': idBarang,
      'id_pembeli': idPembeli,
      'rating': rating,
    };
  }
}
