import 'package:shared_preferences/shared_preferences.dart';
import '../models/doa_model.dart';
import 'dart:convert';

class BookmarkManager {
  static List<Doa> bookmarks = [];

  static Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('bookmarks') ?? [];
    bookmarks = saved.map((e) => Doa.fromJson(json.decode(e))).toList();
  }

  static bool isBookmarked(Doa doa) {
    return bookmarks.any((d) => d.judul == doa.judul);
  }

  static Future<void> toggleBookmark(Doa doa) async {
    final prefs = await SharedPreferences.getInstance();
    if (isBookmarked(doa)) {
      bookmarks.removeWhere((d) => d.judul == doa.judul);
    } else {
      bookmarks.add(doa);
    }
    final encoded = bookmarks.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('bookmarks', encoded);
  }
}
