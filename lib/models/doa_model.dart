class Doa {
  final String judul;
  final String arab;
  final String latin;
  final String arti;
  bool isBookmarked;

  Doa({
    required this.judul,
    required this.arab,
    required this.latin,
    required this.arti,
    this.isBookmarked = false,
  });

  Map<String, dynamic> toJson() => {
    'judul': judul,
    'arab': arab,
    'latin': latin,
    'arti': arti,
    'isBookmarked': isBookmarked,
  };

  factory Doa.fromJson(Map<String, dynamic> json) => Doa(
    judul: json['judul'] ?? '',
    arab: json['arab'] ?? '',
    latin: json['latin'] ?? '',
    arti: json['arti'] ?? '',
    isBookmarked: json['isBookmarked'] ?? false,
  );
}
