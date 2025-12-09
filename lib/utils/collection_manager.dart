// utils/collection_manager.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionManager {
  static const _key = 'bookmark_collections_v2';

  /// Struktur disimpan: { "collections": [ { "name": "My Favorite", "items": ["Doa A","Doa B"] }, ... ] }

  static Future<List<Map<String, dynamic>>> _readCollectionsRaw() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final data = json.decode(raw) as Map<String, dynamic>;
    final list = List<Map<String, dynamic>>.from(data['collections'] ?? []);
    return list;
  }

  static Future<void> _saveCollectionsRaw(
    List<Map<String, dynamic>> coll,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode({'collections': coll});
    await prefs.setString(_key, encoded);
  }

  static Future<List<Map<String, dynamic>>> getCollections() async {
    final list = await _readCollectionsRaw();
    return list;
  }

  static Future<void> addCollection(String name) async {
    final list = await _readCollectionsRaw();
    // hindari duplikat
    if (list.any((c) => c['name'] == name)) return;
    list.add({'name': name, 'items': <int>[]});
    await _saveCollectionsRaw(list);
  }

  static Future<void> deleteCollection(String name) async {
    final list = await _readCollectionsRaw();
    list.removeWhere((c) => c['name'] == name);
    await _saveCollectionsRaw(list);
  }

  static Future<void> renameCollection(String oldName, String newName) async {
    final list = await _readCollectionsRaw();
    if (list.any((c) => c['name'] == newName)) return; // sudah ada
    for (var c in list) {
      if (c['name'] == oldName) {
        c['name'] = newName;
        break;
      }
    }
    await _saveCollectionsRaw(list);
  }

  static Future<void> addItem(String collectionName, int doaId) async {
    final list = await _readCollectionsRaw();
    for (var c in list) {
      if (c['name'] == collectionName) {
        final items = List<int>.from(c['items'] ?? []);
        if (!items.contains(doaId)) {
          items.add(doaId);
          c['items'] = items;
        }
        break;
      }
    }
    await _saveCollectionsRaw(list);
  }

  static Future<void> removeItem(String collectionName, int doaId) async {
    final list = await _readCollectionsRaw();
    for (var c in list) {
      if (c['name'] == collectionName) {
        final items = List<int>.from(c['items'] ?? []);
        items.remove(doaId);
        c['items'] = items;
        break;
      }
    }
    await _saveCollectionsRaw(list);
  }

  static Future<void> addToCollection(String collectionName, int doaId) async {
    final list = await _readCollectionsRaw();
    for (var c in list) {
      if (c['name'] == collectionName) {
        final items = List<int>.from(c['items'] ?? []);
        if (!items.contains(doaId)) {
          items.add(doaId);
          c['items'] = items;
        }
        break;
      }
    }
    await _saveCollectionsRaw(list);
  }

  /// Utility: ensure default collection exists (dipanggil saat init)
  static Future<void> ensureDefaultCollection([
    String name = 'My Favorite',
  ]) async {
    final list = await _readCollectionsRaw();
    if (!list.any((c) => c['name'] == name)) {
      list.add({'name': name, 'items': <int>[]});
      await _saveCollectionsRaw(list);
    }
  }
}
