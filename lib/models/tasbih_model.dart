class Tasbih {
  final String nama;
  int count;

  Tasbih({required this.nama, this.count = 0});

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'count': count,
      };

  factory Tasbih.fromJson(Map<String, dynamic> json) =>
      Tasbih(nama: json['nama'], count: json['count'] ?? 0);
}
