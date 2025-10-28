import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/doa_model.dart';

class LastReadManager {
  static const String _key = 'last_read_doa';

  /// Simpan doa terakhir dibaca
  static Future<void> saveLastRead(Doa doa) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'judul': doa.judul,
      'arab': doa.arab,
      'arti': doa.arti,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await prefs.setString(_key, json.encode(data));
  }

  /// Ambil doa terakhir dibaca
  static Future<Map<String, dynamic>?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    return json.decode(jsonString);
  }

  /// Hapus data last read (optional)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
