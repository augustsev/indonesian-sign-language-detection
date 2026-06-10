class KamusModel {
  final int id;
  final String namaGerakan;
  final String deskripsi;
  final String urlGambar;

  KamusModel({
    required this.id,
    required this.namaGerakan,
    required this.deskripsi,
    required this.urlGambar,
  });

  factory KamusModel.fromJson(Map<String, dynamic> json) {
    return KamusModel(
      id: json['id'],
      namaGerakan: json['nama_gerakan'],
      deskripsi: json['deskripsi'],
      urlGambar: json['url_gambar'],
    );
  }
}
