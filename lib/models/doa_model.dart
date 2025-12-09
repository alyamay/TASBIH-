class Doa {
  final int id;
  final String judul;
  final String latin;
  final String arab;
  final String arti;

  bool isBookmarked;

  Doa({
    required this.id,
    required this.judul,
    required this.latin,
    required this.arab,
    required this.arti,
    this.isBookmarked = false,
  });

  // buat dari API
  factory Doa.fromApi(Map<String, dynamic> json) {
    return Doa(
      id: json['id'],
      judul: json['judul'],
      latin: json['latin'],
      arab: json['arab'],
      arti: json['terjemah'],
    );
  }

  // untuk simpan ke bookmark (local)
  Map<String, dynamic> toJson() => {
    'id': id,
    'judul': judul,
    'latin': latin,
    'arab': arab,
    'arti': arti,
    'isBookmarked': isBookmarked,
  };

  factory Doa.fromJson(Map<String, dynamic> json) {
    return Doa(
      id: json['id'],
      judul: json['judul'],
      latin: json['latin'],
      arab: json['arab'],
      arti: json['arti'],
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }
}
