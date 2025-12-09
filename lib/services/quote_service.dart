import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class QuoteService {
  static const String url = "https://islamic-quotes-api.vercel.app/api/quotes";

  static Future<List<Quote>> fetchAllQuotes() async {
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final List rawList = json.decode(res.body);

      return rawList.map((e) => Quote.fromApi(e)).toList();
    } else {
      throw Exception("Failed to load quotes");
    }
  }
}
