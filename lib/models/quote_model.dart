class Quote {
  final String text;
  final String arabic;
  final String source;

  Quote({required this.text, required this.arabic, required this.source});

  factory Quote.fromApi(Map<String, dynamic> json) {
    return Quote(
      text: json['text'] ?? '',
      arabic: json['arabic'] ?? '',
      source: json['source'] ?? '',
    );
  }
}
