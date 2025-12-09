import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doa_model.dart';

class DoaService {
  static const String baseUrl = "https://open-api.my.id/api";

  /// Ambil semua doa
  static Future<List<Doa>> fetchAllDoa() async {
    final res = await http.get(Uri.parse("$baseUrl/doa"));

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Doa.fromApi(e)).toList();
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  /// Ambil detail doa berdasarkan id
  static Future<Doa> fetchDoaById(int id) async {
    final res = await http.get(Uri.parse("$baseUrl/doa/$id"));

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return Doa.fromApi(data);
    } else {
      throw Exception("Gagal mengambil detail");
    }
  }
}
